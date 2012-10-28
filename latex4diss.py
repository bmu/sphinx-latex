#!/usr/bin/env python
# -*- coding: utf-8 -*-

import codecs
import datetime
import glob
import os
import shutil

import jinja2


class DissLatex(object):
    def __init__(self, old_path, new_path, template, title):
        self.latex_path = old_path
        self.diss_latex_path = new_path
        self.template = template
        self.latex_files = os.listdir(self.latex_path)
        self.title = title
        os.mkdir(new_path)

    def _copy_files(self):
        files = []
        file_extensions = [".png", ".bib", ".sty"]
        for extension in file_extensions:
            files += glob.glob(self.latex_path + "/*" + extension)
            files.append('source/diss.sty')
            for file in files:
                shutil.copy(file, self.diss_latex_path)

    def _parse_tex_file(self):
        # theoretisch koennten es mehrere files sein
        old_sources = glob.glob(self.latex_path + "/*.tex")
        content = ''
        for source in old_sources:
            f = codecs.open(source, encoding="utf-8")
            head, sep, tail = f.read().partition(ur"\chapter{")
            f.close()
            content += sep + tail.split(r"\renewcommand{\indexname}")[0]
        #content = codecs.encode(content, "latin-1")

        return content

    def _make_substitutions(self, content):
        #subst = {r'threeparttable': r'table',
        #         '{tabulary}{\linewidth}': '{tabular}',
        #         r'tabulary': r'tabular'}
        #for element, substitution in subst.iteritems():
        #    content = content.replace(element, substitution)
        return content


    def build(self):
        self._copy_files()
        tex_source = self._parse_tex_file()
        tex_source = self._make_substitutions(tex_source)
        jetzt = datetime.datetime.now()
        monate = ('Januar', 'Februar', u'März', 'April', 'Mai', 'Juni', 'Juli',
                  'August', 'September', 'Oktober', 'November', 'Dezember')
        with codecs.open(self.template, encoding="utf-8") as f:
            template = jinja2.Template(f.read())
        out =  template.render(title = self.title,
                               year = jetzt.year,
                               month = monate[jetzt.month - 1],
                               content = tex_source)
        #out = codecs.encode(out, "latin-1")
        f = codecs.open(self.diss_latex_path + "/diss-bmu.tex", "wb", "utf-8")
        f.write(out)
        f.close()
        return

if __name__ == "__main__":
    new_dir = "build/disslatex"
    diss = DissLatex("build/latex",
                     new_dir,
                     "source/latex_template.tex",
                     u'My complicated title')
    diss.build()
    print "\nModification finished; modified files are in %s" % new_dir
