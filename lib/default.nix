{ lib
, ...
}:

{

  # Makes systemd unit name for mount
  #
  # path: string          path to mount
  #
  # returns: string       unit name
  mkMountName = path: lib.strings.removePrefix "-" "${builtins.replaceStrings [ "/" ] [ "-" ] path}";

  # Make home activation script to link files
  #
  # src: string           source directory
  # dest: string          destination directory
  #
  # returns: DAG entry    script
  mkLinkScript = src: dest: lib.home-manager.hm.dag.entryAfter [ "linkGeneration" ] ''
    if [ -e ${dest} ]; then
      run rm -r ${dest}
    fi
    if [ ! -e ${src} ]; then
      run mkdir -p ${src}
    fi
    run ln -s ${src} ${dest}
  '';
  mkLinkScript' = src: dest: lib.home-manager.hm.dag.entryAfter [ "linkGeneration" ] ''
    if [ -e ${dest} ]; then
      run rm -r ${dest}
    fi
    run ln -s ${src} ${dest}
  '';
}
