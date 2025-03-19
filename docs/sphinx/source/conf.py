# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
import os
import sys
# sys.path.insert(0, os.path.abspath('.'))
from datetime import date


# -- Project information -----------------------------------------------------

project = 'Ramon Documentation'
copyright = '2023-%d, Mi Ramon' % date.today().year
author = 'Mi Ramon'
html_last_updated_fmt = '%b %d, %Y'

# The full version, including alpha/beta/rc tags
release = '1.0-alpha'
version = '1.0-alpha'

# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    'sphinx.ext.mathjax',
    # 'sphinx_sitemap',
    'myst_parser',
    'sphinx_markdown_tables',
    'sphinxcontrib.mermaid',
    'sphinx_copybutton',
    'sphinx_tabs.tabs',
    'sphinx_togglebutton',
]

source_suffix = {
    '.rst':'restructuredtext',
    '.txt':'markdown',
    '.md':'markdown',
}

myst_enable_extensions = {
    "tasklist",
    "deflist",
    "dollarmath",
}

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

language = 'en'

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = ['scripts','CHANGELOG.md','README.md','requirements.txt']


# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
#html_theme = 'alabaster'
# html_theme = 'sphinx_rtd_theme'
# html_theme_options = {
#    'analytics_anonymize_ip': False,
#     'logo_only': False,
#     'display_version': True,
#     'prev_next_buttons_location': 'both',
#     'style_external_links': False,
#     # Toc options
#     'collapse_navigation': True,
#     'sticky_navigation': True,
#     'navigation_depth': 4,
#     'includehidden': True,
#     'titles_only': False,
# }
html_theme = "furo"
html_theme_options = {
    #"source_edit_link": "http://115.25.40.28:8060/tree/sphinx_source.git/master/{filename}",
    "source_view_link": "http://115.25.40.28:8060/summary/sphinx_source.git",
    "light_css_variables": {
        # 亮色模式下的公告栏背景色
        "color-announcement-background": "#e3f2fd",  # 浅蓝色
        "color-announcement-text": "#000000"         # 文字颜色
    },
    "announcement": '🎉🎉🎉<strong>焕新归来！📢📢📢</strong>',
}
html_title = 'Ramon Documentation'
html_search_language = 'zh_CN'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']
# html_logo = "./_static/logo_headpic.png"
html_favicon = "./_static/logo_headpic.png"
html_show_sourcelink = False
# html_css_file = ['css/custom.css']