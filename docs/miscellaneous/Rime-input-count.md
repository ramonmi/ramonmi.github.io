# Rime 输入统计
## 使用前须知
- 使用[新版 librime-lua 引入模块的方式](https://github.com/hchunhui/librime-lua/wiki/Scripting#%E6%96%B0%E7%89%88-librime-lua)，测试版本为[librime.1.16.1](https://github.com/rime/librime)
    - 其他版本可自行测试，如有问题可询问AI或留言。

## 核心脚本
??? info "点击展开`input_count.lua`脚本内容"
    ```lua linenums="1" title="input_count.lua"
    -- 输入统计：上屏字数 + 数按键数

    local M = {}

    -- 存储路径（根据操作系统修改路径，当前为Windows路径）
    local db_path = "D:\\%APPDATA%\\Rime\\dist\\input_count.txt"

    -- 输入统计触发按键（可以改成其他不常用的按键组合）
    local command_key = "sS"

    local save_stat

    local function format_count(n)
        local num = tonumber(n) or 0
        local function trunc(v, digits)
            local p = 10 ^ digits
            return math.floor(v * p) / p
        end
        if num < 1000 then
            return string.format("%d", math.floor(num))
        elseif num < 10000 then
            return string.format("%.2f千", trunc(num / 1000, 2))
        else
            return string.format("%.2f万", trunc(num / 10000, 2))
        end
    end

    local function load_stat()
        if not _G.my_stat then
            _G.my_stat = {
                total_keys = 0,
                total_words = 0,
                day_keys = 0,
                day_words = 0,
                day = os.date("%Y%m%d"),
                last_code = "",
                start_iso = os.date("%Y-%m-%d %H:%M:%S"),
                history = {}
            }
            local f = io.open(db_path, "r")
            if f then
                local history = {}
                for line in f:lines() do
                    local day1, day_words1, day_keys1 = line:match("^day=(%d+)%s+day_words=(%d+)%s+day_keys=(%d+)$")
                    if day1 then
                        table.insert(history, {
                            day = day1,
                            day_words = tonumber(day_words1) or 0,
                            day_keys = tonumber(day_keys1) or 0
                        })
                    else
                        local total_words1, total_keys1 = line:match("^total_words=(%d+)%s+total_keys=(%d+)$")
                        if total_words1 and total_keys1 then
                            _G.my_stat.total_words = tonumber(total_words1) or _G.my_stat.total_words
                            _G.my_stat.total_keys = tonumber(total_keys1) or _G.my_stat.total_keys
                        else
                            local k, v = line:match("([%w_]+)=(.+)")
                            if k and v then 
                                if k == "day" then
                                    _G.my_stat.day = v
                                elseif k == "start_iso" then
                                    _G.my_stat.start_iso = v
                                elseif k == "last_code" then
                                    _G.my_stat.last_code = v
                                elseif k == "total_words" then
                                    _G.my_stat.total_words = tonumber(v) or _G.my_stat.total_words
                                elseif k == "total_keys" then
                                    _G.my_stat.total_keys = tonumber(v) or _G.my_stat.total_keys
                                elseif k == "day_words" then
                                    _G.my_stat.day_words = tonumber(v) or _G.my_stat.day_words
                                elseif k == "day_keys" then
                                    _G.my_stat.day_keys = tonumber(v) or _G.my_stat.day_keys
                                else
                                    _G.my_stat[k] = tonumber(v) or 0
                                end
                            end
                        end
                    end
                end
                f:close()

                if #history > 0 then
                    table.sort(history, function(a, b) return a.day < b.day end)
                    local last = history[#history]
                    _G.my_stat.day = last.day
                    _G.my_stat.day_keys = last.day_keys
                    _G.my_stat.day_words = last.day_words
                    _G.my_stat.history = history
                else
                    _G.my_stat.history = {}
                end
            end
        end

        -- 如果文件不存在，清空内存历史，避免删文件后旧记录残留
        do
            local f = io.open(db_path, "r")
            if f then
                f:close()
            else
                _G.my_stat.history = {}
            end
        end

        -- 按天重置今日统计
        local today = os.date("%Y%m%d")
        if _G.my_stat.day ~= today then
            local history = _G.my_stat.history or {}
            local prev_day = _G.my_stat.day
            local found = false
            for i = 1, #history do
                if history[i].day == prev_day then
                    history[i].day_words = tonumber(_G.my_stat.day_words) or 0
                    history[i].day_keys = tonumber(_G.my_stat.day_keys) or 0
                    found = true
                    break
                end
            end
            if not found and prev_day ~= nil and prev_day ~= "" then
                table.insert(history, {
                    day = prev_day,
                    day_words = tonumber(_G.my_stat.day_words) or 0,
                    day_keys = tonumber(_G.my_stat.day_keys) or 0
                })
            end
            _G.my_stat.history = history

            _G.my_stat.day = today
            _G.my_stat.day_words = 0
            _G.my_stat.day_keys = 0
            _G.my_stat.last_code = ""
            save_stat()
        end

        return _G.my_stat
    end

    function save_stat()
        local f = io.open(db_path, "w")
        if f then
            -- 首行写入起始日期和时间（ISO 8601 格式）
            local start_iso = _G.my_stat.start_iso or os.date("%Y-%m-%d %H:%M:%S")
            _G.my_stat.start_iso = start_iso
            f:write("start_iso=" .. tostring(start_iso) .. "\n")

            -- 第二行写入累计统计
            f:write(string.format(
                "total_words=%d total_keys=%d\n",
                tonumber(_G.my_stat.total_words) or 0,
                tonumber(_G.my_stat.total_keys) or 0
            ))

            -- 按天一行输出统计项
            local history = _G.my_stat.history or {}
            local today = _G.my_stat.day
            local found = false
            for i = 1, #history do
                if history[i].day == today then
                    history[i].day_words = tonumber(_G.my_stat.day_words) or 0
                    history[i].day_keys = tonumber(_G.my_stat.day_keys) or 0
                    found = true
                    break
                end
            end
            if not found then
                table.insert(history, {
                    day = today,
                    day_words = tonumber(_G.my_stat.day_words) or 0,
                    day_keys = tonumber(_G.my_stat.day_keys) or 0
                })
            end
            table.sort(history, function(a, b) return a.day < b.day end)
            _G.my_stat.history = history

            for i = 1, #history do
                local h = history[i]
                f:write(string.format(
                    "day=%s day_words=%d day_keys=%d\n",
                    h.day,
                    h.day_words or 0,
                    h.day_keys or 0
                ))
            end

            -- 其他字段保持兼容
            if _G.my_stat.last_code ~= nil then
                f:write("last_code=" .. tostring(_G.my_stat.last_code) .. "\n")
            end

            f:close()
        end
    end

    -- 核心：通过 Translator 逆向统计（新版 librime Lua 入口使用 func）
    function M.func(input, seg, env)
        local s = load_stat()
        if input == "" then
            s.last_code = ""
            return
        end
        if #input < #s.last_code then
            s.last_code = ""
        end
        
        -- 统计逻辑：如果当前的输入码比上次长，说明按了键
        if input == command_key then
            if s.last_code ~= "" and command_key:sub(1, #s.last_code) == s.last_code then
                local rollback = #s.last_code
                if rollback > 0 then
                    s.total_keys = math.max(0, s.total_keys - rollback)
                    s.day_keys = math.max(0, s.day_keys - rollback)
                end
            end
            s.last_code = input
        elseif input ~= "" and input ~= s.last_code then
            if #input > #s.last_code then
                local diff = #input - #s.last_code
                s.total_keys = s.total_keys + diff
                s.day_keys = s.day_keys + diff
            end
            s.last_code = input
        end

        -- 显示逻辑
        if input == command_key then
            save_stat()
            local day_words = format_count(s.day_words)
            local day_keys = format_count(s.day_keys)
            local total_words = format_count(s.total_words)
            local total_keys = format_count(s.total_keys)
            local from_date = (s.start_iso or ""):match("^(%d%d%d%d%-%d%d%-%d%d)") or ""
            local text = string.format("今日：%s字/%s键 | 总计：%s字/%s键", day_words, day_keys, total_words, total_keys)
            local comment = string.format("[%s—至今]", from_date)
            yield(Candidate("stat", seg.start, seg._end, text, comment))
        end
    end

    -- 捕捉上屏（利用 init 挂载监听，如果监听失效，至少按键数能动）
    function M.init(env)
        load_stat()
        pcall(function()
            env.conn = env.engine.context.commit_notifier:connect(function(ctx)
                local text = ctx:get_commit_text()
                if text ~= "" and text ~= command_key then
                    local _, count = text:gsub("[^\128-\193]", "")
                    _G.my_stat.total_words = _G.my_stat.total_words + count
                    _G.my_stat.day_words = _G.my_stat.day_words + count
                    _G.my_stat.last_code = "" -- 上屏后重置编码追踪
                    save_stat()
                end
            end)
        end)
    end

    function M.processor(key, env)
        return 2 -- 彻底停用此组件的逻辑
    end

    return M
    ```

1. 下载[input_count.lua](https://pub-5ab96ca635214cd7a827a11ffc31194a.r2.dev/BlogImg/1780899841230_input_count.lua)文件，并放在Rime用户文件夹的`lua/`文件夹内。
2. 使用前需**自定义**`lua`脚本中**储存数据的文件路径**，根据自己的系统版本而定，采用绝对路径。
3. 可选自定义`lua`脚本中显示统计数据的按键，默认值：`sS`。

## 配置说明
- 在Rime用户文件夹，对使用的主方案（以下以[雾凇方案](https://github.com/iDvel/rime-ice)为例）进行patch，patch的使用方法参见：[以 patch 的方式打补丁](https://dvel.me/posts/rime-ice/#%e4%bb%a5-patch-%e7%9a%84%e6%96%b9%e5%bc%8f%e6%89%93%e8%a1%a5%e4%b8%81)
- 新建或打开已有的`rime_ice.custom.yaml`，增加以下内容，**注意使用空格缩进，不能使用`Tab`缩进！**

```diff linenums="1" title="rime_ice.custom.yaml新增行"
patch:
  engine/translators:
    ...   # 原有的translators复制过来
+   - lua_translator@*input_count   # 输入统计
```
???+ info "点击展开`rime_ice.custom.yaml`完整配置示例"

    ```yaml linenums="1" hl_lines="17" title="rime_ice.custom.yaml完整配置"
    patch:
    # lua translator 添加
    engine/translators:
      - punct_translator
      - script_translator
      - lua_translator@*date_translator    # 时间、日期、星期
      - lua_translator@*lunar              # 农历
      - lua_translator@*uuid               # UUID
      - table_translator@custom_phrase     # 自定义短语 custom_phrase.txt
      - table_translator@melt_eng          # 英文输入
      - table_translator@cn_en             # 中英混合词汇
      - table_translator@radical_lookup    # 部件拆字反查
      - lua_translator@*unicode            # Unicode
      - lua_translator@*number_translator  # 数字、金额大写
      - lua_translator@*calc_translator    # 计算器
      - lua_translator@*force_gc           # 暴力 GC
      - lua_translator@*input_count        # 输入统计
    ```

- 重新部署Rime输入法，即可启用**输入统计**。启用后首次输入会记录下数据统计起始时间。

## 效果示意
- 在*自定义绝对路径*下的`input_count.txt`文件中记录起始时间、总计输入数据、每天的输入数据。
- 在按下`sS`或*自定义非常用按键*时，输入统计数据在候选框显示。

![](https://pub-5ab96ca635214cd7a827a11ffc31194a.r2.dev/BlogImg/20260207_input_count_demo){ width="600" }

![](https://pub-5ab96ca635214cd7a827a11ffc31194a.r2.dev/BlogImg/20260207_input_count_screenshot){ width="600" }

## 致谢
- [@Kito0615](https://github.com/Kito0615)：[如何在Rime-Squirrel中简单实现输入统计功能。](https://gist.github.com/Kito0615/b6ed63d9de37ddfa84a4bf8fa3372706)
- GPT-5.2-Codex