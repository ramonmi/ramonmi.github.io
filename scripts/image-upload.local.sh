#!/usr/bin/env bash
# Image upload helper. See AGENTS.md for configuration and usage.
set -euo pipefail

die() {
    printf '%s\n' "$*" >&2
    exit 1
}

usage() {
    cat <<'USAGE'
Usage (Git Bash, from the repository root):
  bash "scripts/image-upload.local.sh" upload "local/image.png"
  bash "scripts/image-upload.local.sh" list [keyword] [start=0] [count=20]
  bash "scripts/image-upload.local.sh" check "https://image-url"
  bash "scripts/image-upload.local.sh" markdown "https://image-url" "alt text" [width=900]

Environment:
  IMGBED_BASE_URL       Required for upload/list; HTTPS site root.
  IMGBED_API_TOKEN      Required for upload/list; upload or list permission.
  IMGBED_LIST_FOLDER    Optional for list; defaults to BlogImg/YYYY/MM.
  IMGBED_CHANNEL_NAME   Optional; selects a specific R2 channel.
  IMGBED_REFERER        Optional for check; defaults to https://ramonmi.github.io/.

upload returns one URL; list returns candidate URLs, one per line.
check uses a public GET without credentials; markdown prints a Zensical image.
Uploads use BlogImg/YYYY/MM (Asia/Shanghai) and preserve the source filename.
Uploads use cfr2 with autoRetry=false. No automatic upload retries.
USAGE
}

require_command() {
    command -v "$1" >/dev/null || die "缺少依赖：$1"
}

require_https() {
    case "$1" in
        https://?*) ;;
        *) die '地址必须是完整 HTTPS URL。' ;;
    esac
    case "$1" in
        *[[:space:]]*|*'<'*|*'>'*) die 'URL 含空白或尖括号，请先进行 URL 编码。' ;;
    esac
}

configure_api() {
    require_command curl
    require_command jq
    [ -n "${IMGBED_BASE_URL:-}" ] || die '请设置 IMGBED_BASE_URL。'
    [ -n "${IMGBED_API_TOKEN:-}" ] || die '请注入 IMGBED_API_TOKEN。'
    base_url="${IMGBED_BASE_URL%/}"
    require_https "$base_url"
    local authority="${base_url#https://}"
    case "$authority" in
        *'/'*|*'?'*|*'#'*|*'@'*) die 'IMGBED_BASE_URL 只能包含 HTTPS 协议和站点域名（可含端口）。' ;;
    esac
    case "$IMGBED_API_TOKEN" in
        *$'\r'*|*$'\n'*) die 'Token 不能包含换行。' ;;
    esac
}

current_upload_folder() {
    local year_month
    year_month="$(TZ=Asia/Shanghai date '+%Y/%m')" || die '无法读取当前年月。'
    printf 'BlogImg/%s\n' "$year_month"
}

upload_image() {
    [ "$#" -eq 1 ] || die '用法：upload "可读取的本地图片路径"'
    [ -f "$1" ] && [ -r "$1" ] || die '图片文件不存在或不可读取。'
    configure_api
    local image_file="$1" response image_url upload_folder
    upload_folder="$(current_upload_folder)" || return 1
    local -a channel_args=()
    if [ -n "${IMGBED_CHANNEL_NAME:-}" ]; then
        channel_args=(--url-query "channelName=${IMGBED_CHANNEL_NAME}")
    fi

    # curl supplies the multipart boundary; quoted filenames allow spaces/commas.
    if ! response="$(curl --disable --silent --show-error --fail-with-body \
        --proto '=https' --connect-timeout 15 --max-time 180 \
        --request POST \
        --header "Authorization: Bearer ${IMGBED_API_TOKEN}" \
        --url-query 'uploadChannel=cfr2' \
        --url-query 'autoRetry=false' \
        --url-query 'returnFormat=full' \
        --url-query 'uploadNameType=origin' \
        --url-query "uploadFolder=${upload_folder}" \
        "${channel_args[@]}" \
        --form "file=@\"${image_file}\"" \
        "${base_url}/upload")"; then
        die '上传失败；核查 HTTP 状态、凭据及 R2 配置，确认是否已写入后再决定重传。'
    fi

    if ! image_url="$(printf '%s' "$response" | jq -er '
        if type == "array" and length == 1 then
            .[0]
            | if (.publicUrl | type) == "string" and (.publicUrl | length) > 0
              then .publicUrl else .src end
            | select(type == "string" and length > 0)
        else empty end
    ')"; then
        die '响应未包含有效图片地址；核查服务端结果，勿直接重传。'
    fi
    case "$image_url" in
        https://*) ;;
        //*) die '响应地址格式异常，请人工核查。' ;;
        /*) image_url="${base_url}${image_url}" ;;
        *) die '响应不是 HTTPS URL 或站内路径，请核查。' ;;
    esac
    require_https "$image_url"
    printf '%s\n' "$image_url"
}

list_images() {
    [ "$#" -le 3 ] || die '用法：list [关键词] [起始位置] [每页条数]'
    local keyword="${1:-}" start="${2:-0}" count="${3:-20}" response list_folder
    [[ "$start" =~ ^[0-9]+$ ]] || die '起始位置必须是非负整数。'
    [[ "$count" =~ ^[1-9][0-9]*$ ]] || die '每页条数必须是正整数。'
    configure_api
    list_folder="${IMGBED_LIST_FOLDER:-$(current_upload_folder)}"
    local -a channel_args=()
    if [ -n "${IMGBED_CHANNEL_NAME:-}" ]; then
        channel_args=(--url-query "channelName=CloudflareR2:${IMGBED_CHANNEL_NAME}")
    fi
    if ! response="$(curl --disable --silent --show-error --fail-with-body \
        --proto '=https' --connect-timeout 15 --max-time 60 \
        --header "Authorization: Bearer ${IMGBED_API_TOKEN}" \
        --url-query "dir=${list_folder}" \
        --url-query "search=${keyword}" \
        --url-query 'channel=CloudflareR2' \
        --url-query 'recursive=true' \
        --url-query "start=${start}" --url-query "count=${count}" \
        "${channel_args[@]}" \
        "${base_url}/api/manage/list")"; then
        die '查询失败；确认 Token 具有 list 权限，并核查目录和 R2 通道。'
    fi
    if ! printf '%s' "$response" | jq -e 'type == "object" and (.files | type) == "array"' >/dev/null; then
        die '列表响应格式异常，未包含 files 数组。'
    fi
    if [ "$(printf '%s' "$response" | jq '.files | length')" -eq 0 ]; then
        printf '%s\n' '本页无匹配文件；可调整关键词、目录或分页，不要直接重传。' >&2
    fi
    printf '%s' "$response" | jq -r --arg base "$base_url" '
        .files[]
        | select((.name | type) == "string" and (.name | length) > 0)
        | .name | split("/") | map(@uri) | join("/")
        | $base + "/file/" + .
    '
}

check_image() {
    [ "$#" -eq 1 ] || die '用法：check "HTTPS 图片 URL"'
    require_command curl
    require_https "$1"
    local result status content_type
    if ! result="$(curl --disable --silent --show-error --fail --location \
        --proto '=https' --proto-redir '=https' \
        --connect-timeout 15 --max-time 60 \
        --referer "${IMGBED_REFERER:-https://ramonmi.github.io/}" \
        --output "/dev/null" \
        --write-out '%{http_code}\n%{content_type}' "$1")"; then
        die '图片读取失败；核查公开访问、防盗链和 URL。'
    fi
    # Native Windows curl emits CRLF; normalize before parsing its metadata.
    result="${result//$'\r'/}"
    status="${result%%$'\n'*}"
    content_type="${result#*$'\n'}"
    case "$status" in
        2[0-9][0-9]) ;;
        *) die '图片未返回成功 HTTP 状态。' ;;
    esac
    case "${content_type,,}" in
        image/*) ;;
        *) die '响应不是 image/*，请核查是否返回了 HTML 或登录页。' ;;
    esac
    printf 'HTTP=%s\nContent-Type=%s\n' "$status" "$content_type"
}

image_markdown() {
    [ "$#" -ge 2 ] && [ "$#" -le 3 ] || die '用法：markdown "HTTPS 图片 URL" "图片说明" [宽度]'
    require_https "$1"
    local alt="$2" width="${3:-900}"
    [[ "$width" =~ ^[1-9][0-9]*$ ]] || die '图片显示宽度必须是正整数。'
    case "$alt" in
        *$'\r'*|*$'\n'*) die '图片说明不能包含换行。' ;;
    esac
    alt="${alt//\\/\\\\}"
    alt="${alt//[/\\[}"
    alt="${alt//]/\\]}"
    printf '![%s](<%s>){ loading=lazy width="%s" }\n' "$alt" "$1" "$width"
}

if [ "$#" -eq 0 ]; then
    usage >&2
    exit 2
fi
command_name="$1"
shift
case "$command_name" in
    upload) upload_image "$@" ;;
    list) list_images "$@" ;;
    check) check_image "$@" ;;
    markdown) image_markdown "$@" ;;
    help|--help|-h) usage ;;
    *) usage >&2; die "未知命令：$command_name" ;;
esac
