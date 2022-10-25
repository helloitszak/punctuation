# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  zsh-async = {
    pname = "zsh-async";
    version = "v1.8.5";
    src = fetchFromGitHub ({
      owner = "mafredri";
      repo = "zsh-async";
      rev = "v1.8.5";
      fetchSubmodules = false;
      sha256 = "sha256-mpXT3Hoz0ptVOgFMBCuJa0EPkqP4wZLvr81+1uHDlCc=";
    });
  };
  zsh-history-substring-search = {
    pname = "zsh-history-substring-search";
    version = "v1.0.2";
    src = fetchFromGitHub ({
      owner = "zsh-users";
      repo = "zsh-history-substring-search";
      rev = "v1.0.2";
      fetchSubmodules = false;
      sha256 = "sha256-Ptxik1r6anlP7QTqsN1S2Tli5lyRibkgGlVlwWZRG3k=";
    });
  };
  zsh-syntax-highlighting = {
    pname = "zsh-syntax-highlighting";
    version = "0.7.1";
    src = fetchFromGitHub ({
      owner = "zsh-users";
      repo = "zsh-syntax-highlighting";
      rev = "0.7.1";
      fetchSubmodules = false;
      sha256 = "sha256-gOG0NLlaJfotJfs+SUhGgLTNOnGLjoqnUp54V9aFJg8=";
    });
  };
}
