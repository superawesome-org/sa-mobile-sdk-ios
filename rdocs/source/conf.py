import sys
import os
extensions = []
templates_path = ['_templates']
source_suffix = '.rst'
master_doc = 'index'
project = u'iOS SDK'
copyright = u'2016, SuperAwesome Ltd'
author = u'Gabriel Coman'
version = u'3.8.1'
release = u'3.8.1'
language = None
exclude_patterns = []
show_authors = True
pygments_style = 'sphinx'
todo_include_todos = False
html_theme = 'sphinx_rtd_theme'
html_theme_options = {"logo_only":True}
html_theme_path = ["themes",]
html_logo = 'themeres/logo.png'
html_static_path = ['_static']
htmlhelp_basename = 'SuperAwesomeiOSSDKdoc'
latex_elements = {}
latex_documents = [
    (master_doc, 'SuperAwesomeiOSSDK.tex', u'SuperAwesome iOS SDK Documentation',u'Gabriel Coman', 'manual'),
]
man_pages = [
    (master_doc, 'superawesomeiossdk', u'SuperAwesome iOS SDK Documentation',[author], 1)
]
texinfo_documents = [
    (master_doc, 'SuperAwesomeiOSSDK', u'SuperAwesome iOS SDK Documentation', author, 'SuperAwesomeiOSSDK', 'One line description of project.', 'Miscellaneous'),
]
html_context = {
    'all_versions' : [u'3.8.1'],
    'domain': 'AwesomeAds',
    'sourcecode': 'https://github.com/SuperAwesomeLTD/sa-mobile-sdk-ios'
}
