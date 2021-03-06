%%
%% This is file `wtpl3doc.cls'.
%%
%% Copyright 2020 Takuto ASAKURA (wtsnjp)
%%   GitHub:   https://github.com/wtsnjp
%%   Twitter:  @wtsnjp
%%
%% This class is distributed under the MIT License.
%%

%% Note: このファイルは日本語文字を含みます.

%% 依存パッケージ
\RequirePackage{expl3,xparse,tcolorbox,plautopatch}
\tcbuselibrary{skins,breakable,xparse}

%% クラス宣言
\NeedsTeXFormat{pLaTeX2e}
\ProvidesExplPackage {wtpl3doc} {2020/05/24} {0.1.0}
  {L3 Experimental documentation class for pLaTeX}

%% クラスオプション
% 既知の l3doc オプションは l3doc に渡す
\clist_const:Nn \c__wtpl_codedoc_options_clist
  {
    a5paper, onlydoc, check, nocheck, checktest, nochecktest,
    kernel, stdmodule, cm-default, lm-default, cs-break-off,
    cs-break-nohyphen, show-notes, hide-notes,
  }
\clist_map_inline:Nn \c__wtpl_codedoc_options_clist
  {
    \DeclareOption {#1} {
      \PassOptionsToClass { \CurrentOption } { l3doc }
    }
  }
% full について特別の対処
\bool_new:N \g__wtpl_full_bool
\DeclareOption { full }
  {
    \bool_gset_true:N \g__wtpl_full_bool
    \PassOptionsToClass { \CurrentOption } { l3doc }
  }

% それ以外は jsarticle に渡す
\DeclareOption*
  {
    \PassOptionsToClass { \CurrentOption } { jsarticle }
  }
\PassOptionsToClass { a4paper } { jsarticle }
\PassOptionsToClass { nomag } { jsarticle }
\ProcessOptions \scan_stop:

%% l3doc を読み込む
% textcomp のオプションクラッシュ防止
\bool_if:nT { \g__wtpl_full_bool }
  { \RequirePackage [ full ] { textcomp } }

% l3doc は内部で article を呼ぶので，代わりに jsarticle を呼ぶように細工
\cs_new_eq:NN \__wtpl_original_load_class:n \LoadClass
\cs_new_eq:NN \__wtpl_original_pass_options_to_class:nn \PassOptionsToClass
\cs_new:Npn \__wtpl_load_class:n #1
  {
    \tl_if_eq:nnTF {#1} { article }
      { \__wtpl_original_load_class:n { jsarticle } }
      { \__wtpl_original_load_class:n {#1} }
  }
\cs_new:Npn \__wtpl_pass_options_to_class:nn #1#2
  {
    \tl_if_eq:nnTF {#2} { article }
      { \__wtpl_original_pass_options_to_class:nn {#1} { jsarticle } }
      { \__wtpl_original_pass_options_to_class:nn {#1} {#2} }
  }
\cs_set_eq:NN \LoadClass \__wtpl_load_class:n
\__wtpl_original_load_class:n { l3doc }
\cs_set_eq:NN \LoadClass \__wtpl_original_load_class:n
\cs_set_eq:NN \PassOptionsToClass \__wtpl_original_pass_options_to_class:nn

%% 余白設定（TODO: 要検討）
\addtolength \marginparwidth { -20pt }
\addtolength \oddsidemargin  {  55pt }
\addtolength \evensidemargin {  55pt }

%% 日本語用設定
\DeclareTextFontCommand { \emph } { \sffamily\gtfamily }

% 目次（jsarticle の設定を復帰）
\cs_gset:Npn \l@section #1#2
  {
    \ifnum \c@tocdepth >\z@
      \addpenalty{\@secpenalty}%
      \addvspace{1.0em \@plus\jsc@mpt}%
      \begingroup
        \parindent\z@
        \rightskip\@tocrmarg
        \parfillskip-\rightskip
        \leavevmode\headfont
        %\setlength\@lnumwidth{4zw}% 元1.5em [2003-03-02]
        \setlength\@lnumwidth{\jsc@tocl@width}\advance\@lnumwidth 2zw
        \advance\leftskip\@lnumwidth \hskip-\leftskip
        #1\nobreak\hfil\nobreak\hbox to\@pnumwidth{\hss#2}\par
      \endgroup
    \fi
  }
\cs_gset:Npn \l@subsection
  {
    \@tempdima\jsc@tocl@width \advance\@tempdima -1zw
    \@dottedtocline{2}{\@tempdima}{3zw}
  }

%% 枠
\cs_new_eq:NN \__wtpl_codedoc_function_end: \__codedoc_function_end:
\DeclareTColorBox { texnote } {}
  {
    empty, left=2mm, right=2mm, top=-1mm,
    attach~boxed~title~to~top~left={xshift=1.2zw},
    boxed~title~style={
      empty, left=-1mm, right=-1mm,
    },
    colframe=black, coltitle=black, coltext=black,
    %breakable,  % function環境の中だとうまくいかないことがある
    underlay~unbroken={
      \draw [black, line~width=.5pt]
        (title.east) -- (title.east-|frame.east) -- (frame.south~east)
          -- (frame.south~west) -- (title.west-|frame.west) -- (title.west);
    },
    underlay~first={
      \draw [black, line~width=.5pt] (title.east) -- (title.east-|frame.east)
        -- (frame.south~east);
      \draw [black, line~width=.5pt] (frame.south~west)
        -- (title.west-|frame.west) -- (title.west);
    },
    underlay~middle={
      \draw [black, line~width=.5pt]
        (frame.north~east) -- (frame.south~east) ;
      \draw [black, line~width=.5pt] (frame.south~west) -- (frame.north~west) ;
    },
    underlay~last={
      \draw [black, line~width=.5pt] (frame.north~east) -- (frame.south~east)
        -- (frame.south~west) -- (frame.north~west) ;
    },
    fonttitle=\sffamily\gtfamily,
    title={\TeX 言語者向けノート},
  }

% vim: ft=expl3 nospell:
%% EOF
