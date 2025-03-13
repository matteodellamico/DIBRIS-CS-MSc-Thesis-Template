%%
%%    File : disithesis.cls    (LaTeX2e class file)
%%  Author(s) : Davide Ancona (davide.ancona@unige.it) 
%%            : Davide Ancona (davide.ancona@unige.it) 
%% Version : 1.0 [17/10/2018]
%%
%% This file contains a class definition, disithesis, for the LaTeX2e
%% system which defines the layout of theses which are submitted in
%% the Department of Computer Science at the University of Genova.
%%
%%

\NeedsTeXFormat{LaTeX2e}[1994/12/01]
\ProvidesClass{masterthesis}[2018/10/18 v1.0]

%%
%% --- Initial Code ---
%%

\RequirePackage{ifthen}
\RequirePackage{graphics}

\newcommand{\degreetext}{}
\newcommand{\department}{Dipartimento di Informatica, Bioingegneria, Robotica e Ingegneria dei Sistemi (DIBRIS)}
\newcommand{\university}{Universit\`a degli Studi di Genova}
\newcommand{\@chapteralignment}{\centering}
\newcommand{\draftmessage}{}
\newboolean{draftthesis}
\newboolean{usedoublespacing}
\newboolean{usedeptreport}
\newboolean{sizespecified}
\newboolean{nocoverpage}


%%
%%  --- Options ---
%%
%%  Current options: final, 
%%                   draft,
%%                   singlespacing, doublespacing, 
%%                   leftchapter, centerchapter, rightchapter,
%% 		     nocoverpage,
%%                   + all report.cls options
%%
%%  Default:         final,singlespacing,leftchapter,12pt,a4paper
%%                   + all remaining report.cls default options

\DeclareOption{final}{\renewcommand{\degreetext}{
    Computer Science MSc\\
    \small Computer Security and Engineering Curriculum}}

\DeclareOption{centerchapter,centrechapter}
   {\renewcommand{\@chapteralignment}{\centering}}
\DeclareOption{leftchapter}
   {\renewcommand{\@chapteralignment}{\raggedright}}
\DeclareOption{rightchapter}
   {\renewcommand{\@chapteralignment}{\raggedleft}}

\DeclareOption{nocoverpage}
   {\setboolean{nocoverpage}{true}}

\DeclareOption{draft}{
   \setboolean{draftthesis}{true}
   \setboolean{nocoverpage}{true}
   \renewcommand{\draftmessage}{(Draft Copy)}
   \PassOptionsToClass{draft}{report}}


\DeclareOption{doublespacing}{\setboolean{usedoublespacing}{true}}

\DeclareOption{10pt}
   {\setboolean{sizespecified}{true}\PassOptionsToClass{10pt}{report}}
\DeclareOption{11pt}
   {\setboolean{sizespecified}{true}\PassOptionsToClass{11pt}{report}}
\DeclareOption{12pt}
   {\setboolean{sizespecified}{true}\PassOptionsToClass{12pt}{report}}

\DeclareOption{twoside}{\PassOptionsToClass{twoside,openright}{report}}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}

\ExecuteOptions{final,leftchapter,singlespacing} % the default options
\ProcessOptions


%%
%% --- Class Loading (built ontop of report.cls) ---
%%

\ifthenelse{\boolean{sizespecified}}
{\LoadClass[a4paper]{report}}
{\LoadClass[a4paper,12pt]{report}}


%%
%% --- Main Code ---
%%

\newboolean{isspecialchapter}
\setboolean{isspecialchapter}{false}
\newcounter{disicnt}

%%
%% Set margins 
%%

\ifcase \@ptsize
% mods for 10 pt
  \if@twoside
    \oddsidemargin  0.15in
    \evensidemargin 0.35in
    \marginparwidth 1 in       
  \else
    \oddsidemargin  0.25in
    \evensidemargin 0.25in
    \marginparwidth 0.75 in
  \fi
  \textwidth 5.875 in
\or 
% mods for 11 pt
   \if@twoside
    \oddsidemargin  0.1in
    \evensidemargin 0.15in
    \marginparwidth 1 in
  \else
    \oddsidemargin  0.125in
    \evensidemargin 0.125in
    \marginparwidth 0.75 in
  \fi   
  \textwidth 6.125 in 
\or 
% mods for 12 pt
   \if@twoside
    \oddsidemargin  -10pt
    \evensidemargin  10pt
    \marginparwidth 1 in   
  \else
    \oddsidemargin  0 in
    \evensidemargin 0 in
    \marginparwidth 0.75 in   
  \fi       
  \textwidth 6.375 true in
\fi

%%
%% Parskip
%%

\AtBeginDocument{\parindent 0pt}

%% Do not reset the page number to one
%% This avoid clash on page identifier
\renewenvironment{titlepage}
 {%
  \if@twocolumn
    \@restonecoltrue\onecolumn
  \else
    \@restonecolfalse\newpage
  \fi
  \thispagestyle{empty}%
 }
 {%
  \if@restonecol
    \twocolumn
  \else
    \newpage
  \fi
 }

%%
%% Hack to make minitoc work with csthesis. We declare a new chapter
%% variable called starchapter to be used by \addcontentsline when we
%% add contents lines for List of Figures/Tables. If we don't, then
%% minitoc treats the LOF/LOT sections as chapters of the thesis.
%%

\@ifundefined{chapter}{}{\let\l@starchapter\l@chapter}

%%
%% This bit will set up the header format for the thesis.
%% This currently uses a "headings" style showing the pagenumber
%% and chapter number/title. (in slanted text)
%%

\renewcommand{\chaptermark}[1]{\markboth{#1}{#1}}
\newcommand{\chapternoheader}{
  \ifthenelse{\boolean{isspecialchapter}}
    {}
    {\chaptername\ \thechapter\ \ ---\ }
}

\newcommand{\headfootstyle}{\normalsize}  % font size of headers and footers

\renewcommand{\ps@headings}{
  \renewcommand{\@oddfoot}{}
  \renewcommand{\@evenfoot}{}
  \renewcommand{\@evenhead}{\headfootstyle\thepage\hfil\textsl\chapternoheader%
                            \leftmark\ \draftmessage}
  \renewcommand{\@oddhead}{\hskip -0.35em {\textsl\headfootstyle\chapternoheader%
                           \rightmark\ \draftmessage}\hfil\thepage}
}

\renewcommand{\ps@plain}{
  \renewcommand{\@oddfoot}{\hfil\headfootstyle\thepage\hfil}
  \renewcommand{\@evenfoot}{\hfil\headfootstyle\thepage\hfil}
  \renewcommand{\@evenhead}{}
  \renewcommand{\@oddhead}{}
}

%%
%% And now setup that headings style as default
%%

\newcommand{\@textpagenumbering}{arabic}
\newcommand{\@preamblepagenumbering}{roman}
\newcommand{\@textpagestyle}{plain}
\newcommand{\@preamblepagestyle}{plain}

\pagestyle{\@preamblepagestyle}

\setcounter{secnumdepth}{6}

%%
%% Set up the default names for the various chapter headings
%%

\renewcommand{\contentsname}{Table of Contents}
\renewcommand{\listfigurename}{List of Figures}
\renewcommand{\listtablename}{List of Tables}
\renewcommand{\bibname}{Bibliography}
\renewcommand{\indexname}{Index}
\renewcommand{\abstractname}{Abstract}


%%
%% Set up the double spacing and provide commands to alter the
%% spacing for the subsequent text. By default, 1.5 spacing will be
%% used. This can be modified through the singlespacing, doublespacing
%% or draft class options.
%%


\newcommand{\doublespace}{\baselineskip 24pt
                          \parskip 24pt
                          \parsep 26.4pt}
\newcommand{\oneandahalfspace}{\baselineskip 18pt
                               \parskip 19.8pt
                               \parsep 19.8pt}
\newcommand{\singlespace}{\baselineskip 14.4pt
                          \parskip 7.2pt
                          \parsep 7.2pt}

\ifthenelse{\boolean{usedoublespacing}}
   {\AtBeginDocument{\doublespace}}
   {\AtBeginDocument{\singlespace}}


%%
%% When printing twosided, then the title page must be followed by
%% a blank page so that the thesis begins on the right-hand page. 
%% Also we must ensure that the thesis ends on a lef-hand page. We
%% do the latter by issuing a \cleardoublepage at the end of document.
%%


\newcommand{\cscleardoublepage}%
  {\newpage{\pagestyle{empty}
   \cleardoublepage}}
\AtEndDocument{\cscleardoublepage}


%%
%% Quotations are supposed to be in single-space, so we will
%% explicitly redefine the quotation env. to support this.
%% And introduce a citetext env. which can add an attribution.
%%

\renewenvironment{quotation}
   {\begin{quote}\singlespace\textsl}
   {\end{quote}}

\newcommand{\citationname}{}
\newenvironment{citetext}[1]
   {\thispagestyle{empty}
    \renewcommand{\citationname}{#1}
    \begin{quote}\singlespace
    \textsl}
   {
    \hspace*{\fill}\nolinebreak[1]\hspace*{\fill}
    \rm (\citationname)\end{quote}}

%%
%% Let's have a dedication page so I can thank my mummy.
%%

\newcommand{\dedication}[1]
   {\cscleardoublepage
    \titlepage\null\vspace{2.5in}
    \begin{center}#1\end{center}
    \par\vfil\null\endtitlepage}

%%
%% Now let's redefine the abstract env. so that the title is 
%% comparable to other chapter headings. Also have abstract
%% start at top of page instead of floating in the middle
%%


\renewenvironment{abstract}
   {\cscleardoublepage
    \titlepage\null\vspace{1cm}
    \begin{center}
       \bfseries \LARGE\abstractname
    \end{center}}
   {\par\vfil\null\endtitlepage}

%%
%% Based upon the above abstract env., provide wrappers for
%% an acknowledgements and declation env.
%%

\newenvironment{acknowledgements}
   {\renewcommand{\abstractname}{Acknowledgements}\begin{abstract}}
   {\end{abstract}\renewcommand{\abstractname}{Abstract}}   

\newenvironment{addresspage}
   {\cscleardoublepage
    \titlepage\null\vspace{0cm}
    \begin{center}}
    {\end{center}
    \par\vfil\null\endtitlepage}

%%
%% Now let's look at the format for the title page of the
%% thesis. This is done by redefining \maketitle, and allowing
%% some extra input options: \submityear and \submitmonth
%%

\def\submityear#1{\gdef\@submityear{#1}}
\gdef\@submityear{\the\year}

\def\submitmonth#1{\gdef\@submitmonth{#1}}
\gdef\@submitmonth{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi}

%\def\technumber#1{\gdef\@technumber{#1}}

\def\advisor#1{\gdef\@advisor{#1}}

\def\examiner#1{\gdef\@examiner{#1}}

\ifthenelse{\boolean{nocoverpage}}
{
\renewcommand{\maketitle}{
      \begin{titlepage}\begin{center}
      \null\vfil\vskip 10\p@
      {\Large\bfseries \university \vskip 10\p@
                       \department \vskip 10\p@
                       \degreetext  
         \ifthenelse{\boolean{draftthesis}}
                    {\vskip 0\p@\large (Draft Copy)}{}\vskip 40\p@}
                    {\LARGE   \bfseries\@title \vskip 10\p@}
         {\Large by \vskip 10\p@
                            \@author \vskip 10\p@}     
      \vfill
      {\Large \@submitmonth, \@submityear}
      \end{center}\end{titlepage}
   }
}%%%% endif
{%%%% else
\renewcommand{\maketitle}{
\begin{titlepage}%
  {%
      \begin{tabular}[b]{l}
        \includegraphics[width=.7\textwidth]{dibris_extended_black} \\
   \end{tabular} 
   
   %\hrulefill

   \vfill

   \begin{center}\LARGE
   {\bfseries \@title}\\
   \ \\
   \ \\
   \@author
   \end{center}

   \vfill

   {\large
    Master's Thesis  %%\hfill {\bfseries DIBRIS-TH-\@submityear-\@technumber}
    %%%Technical Reports Series \hfill {\bf DISI-TR-\@submityear-\@technumber}
   }
   %\hrulefill

   
\vskip 50\p@
   {\normalsize
   Universit\`a di Genova, DIBRIS \\
     Via Dodecaneso, 35
     16146 Genova, Italy\\
   \hfill \url{https://www.dibris.unige.it/}}}%
  \vfil\null
  \end{titlepage}%

      \begin{titlepage}\begin{center}
      \null\vfil
      \includegraphics[width=.2\textwidth]
      {logo_verticale_BLACK}\vskip 40\p@
      {\Large\bfseries 
                       \degreetext  
         \ifthenelse{\boolean{draftthesis}}
                    {\vskip 0\p@\large (Draft Copy)}{}\vskip 40\p@}
                    {\LARGE   \bfseries\@title \vskip 60\p@}
         {\Large 
           \@author \vskip 60\p@
Advisor: \@advisor  \hskip \fill  Examiner: \@examiner \vskip 10\p@
         }     
      \vfill
          {\Large \@submitmonth, \@submityear}
      \end{center}\end{titlepage}
   }
}%%%%endelse

%%
%% Now we can redefine the chapter headings, with the flexibility
%% to choose whether we want the headings to be left, right or
%% centre justified. N.B. Most of this code is replicated from
%% the utthesis.sty style: version 1.0, (c) 1994 Dinesh Das
%%

\newcommand{\specialchapter}[1]{
   \chapter*{#1\@mkboth{\MakeUppercase#1}{\MakeUppercase#1}}
   \addcontentsline{toc}{chapter}{#1}
   \chaptermark{#1}
   \setboolean{isspecialchapter}{true}
}

\renewcommand{\chapter}{
\if@openright\cleardoublepage\else\clearpage\fi
   \thispagestyle{plain}%
%   \setboolean{isspecialchapter}{false}
   \global\@topnum\z@
   \@afterindentfalse
   \secdef\@chapter\@schapter
   }

%%%
%%% Command from report.cls, (c) LaTeX3 Project.
%%%

\def\@chapter[#1]#2{\ifnum \c@secnumdepth >\m@ne
                      \refstepcounter{chapter}%
                      \typeout{\@chapapp\space\thechapter.}%
                      \addcontentsline{toc}{chapter}%
                             {\@chapapp\ \protect\numberline{\thechapter}#1}%
                    \else
                      \addcontentsline{toc}{chapter}{\@chapapp\ #1}
                    \fi
                    \ifnum\value{chapter}=1\pagestyle{\@textpagestyle}\fi%
                    \chaptermark{#1}%
                    \addtocontents{lof}{\protect\addvspace{10\p@}}%
                    \addtocontents{lot}{\protect\addvspace{10\p@}}%
                    \@makechapterhead{#2}%
                    \@afterheading
                    }
%%%
%%% Command from report.cls, (c) LaTeX3 Project.
%%%

\def\@makechapterhead#1{%
  \vspace*{50\p@}%
  {\parindent \z@ \@chapteralignment \reset@font
    \ifnum \c@secnumdepth >\m@ne
      \huge\bfseries \@chapapp{} \thechapter
      \par
      \vskip 20\p@
    \fi
    \Huge \bfseries #1\par
    \nobreak
    \vskip 40\p@
  }}
\def\@makeschapterhead#1{%
  \vspace*{50\p@}%
  {\parindent \z@ \@chapteralignment
    \reset@font
    \Huge \bfseries  #1\par
    \nobreak
    \vskip 40\p@
  }}

%\newcommand{\setbibliographyheader}{
%   \chaptermark{\bibname}
%   \setboolean{isspecialchapter}{true}
%}

%%
%% Updated thebibliography environment. 
%% Modified from report.cls v1.3q (c) LaTeX3 Project.
%% Now includes entry in contents page & supports title rejustifying
%%

\renewenvironment{thebibliography}[1]
     {\specialchapter{\bibname}
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy\clubpenalty4000\widowpenalty4000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}

%%
%% Updated listoftables environment. 
%% Modified from report.cls v1.3q (c) LaTeX3 Project.
%% Now includes entry in contents page & supports title rejustifying
%%

\renewcommand\listoftables{%
    \chapter*{\listtablename
      \@mkboth{%
          \MakeUppercase\listtablename}{\MakeUppercase\listtablename}}%
     \addcontentsline{toc}{starchapter}{\listtablename}
    \@starttoc{lot}%
    }

%%
%% Updated listoffigures environment. 
%% Modified from report.cls v1.3q (c) LaTeX3 Project.
%% Now includes entry in contents page & supports title rejustifying
%%

\renewcommand\listoffigures{%
    \chapter*{\listfigurename
      \@mkboth{\MakeUppercase\listfigurename}%
              {\MakeUppercase\listfigurename}}%
    \addcontentsline{toc}{starchapter}{\listfigurename}
    \@starttoc{lof}%
    }

%%
%% Redefine the appendix command to ensure that it does a pagebreak
%% (sorts problem of Appendix appearing in header of last page before
%% the first apppendix).
%%

\renewcommand{\appendix}{\vfill\pagebreak
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  \renewcommand\@chapapp{\appendixname}%
  \renewcommand\chaptername{\appendixname}%
  \renewcommand\thechapter{\@Alph\c@chapter}
}


%%
%% EOF: masterthesis.cls
%%
