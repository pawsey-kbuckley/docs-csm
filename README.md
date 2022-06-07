---
layout: default
---

---
layout: default
---

# Cray System Management (CSM) - README

This file is on a branch that allows for rendering of the content
with the Jekyll rendering tools.

There's no "fancy" style being applied at present but it does act
as a useful check to make sure that the way the Markdown is being
written doesn't preculde rendering with Jekyll.

Along with

* Adding some tooling files and scripts
* Adding some headers to all of the Markdown files
* Rewriting links so that they refer to the rendered dot-html
  files and not the dot-md source files

the main issue so far has been seen to be the way that some date
command format strings, which use curly brace plus percent as a
delimiter, within code blocks, require, for rendering with Jekyll,
the code block to be qualified with a raw/endraw pair.

Typically, one would do

* `make  jekyll-add-def-header`
* `make  jekyll-replace-md-links`
* `make  jekyll-show-brace_percent_str`

At this point, one can either protect the identified code blocks
by hand, or simply protect everyone, with a 

* `make jekyll-protect-code-blocks`

after which running a `jekyll build` or `jekyll serve` should
complete.

The branch can be returned to a clean state, after any Jekyll
work, by running

* `make jekyll-clean`

## The original content of the "main" branch README follows:

The documentation included here describes how to install or upgrade the Cray System Management (CSM)
software and related supporting operational procedures. CSM software is the foundation upon which
other software product streams for the HPE Cray EX system depend.

This documentation is in Markdown format. Although much of it can be viewed with any text editor,
a richer experience will come from using a tool which can render the Markdown to show different font
sizes, the use of bold and italics formatting, inclusion of diagrams and screen shots as image files,
and to follow navigational links within a topic file and to other files.

There are many tools which can render the Markdown format to get these advantages. Any Internet search
for Markdown tools will provide a long list of these tools. Some of the tools are better than others
at displaying the images and allowing you to follow the navigational links.

The exploration of the CSM documentation begins with
the [Cray System Management Documentation](index.html) which introduces
topics related to CSM software installation, upgrade, and operational use. Notice that the
previous sentence had a link to the index.md file for the Cray System Management Documentation.
If the link does not work, then a better Markdown viewer is needed.
