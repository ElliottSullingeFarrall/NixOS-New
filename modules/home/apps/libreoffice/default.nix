{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.apps.libreoffice;
  inherit (cfg) enable;
in
{
  options = {
    apps.libreoffice.enable = lib.mkEnableOption "Install LibreOffice.";
  };

  config = lib.mkIf enable {
    /* -------------------------------------------------------------------------- */
    /*                                  Packages                                  */
    /* -------------------------------------------------------------------------- */

    home.packages = with pkgs; [
      libreoffice-qt-still
    ];

    /* -------------------------------------------------------------------------- */
    /*                                   Desktop                                  */
    /* -------------------------------------------------------------------------- */

    xdg.desktopEntries."startcenter" = {
      name = "LibreOffice";
      genericName = "Office";
      comment = "Launch applications to create text documents, spreadsheets, presentations, drawings, formulas, and databases, or open recently used documents.";
      icon = "libreoffice-startcenter";
      noDisplay = false;

      exec = "soffice %U";
      type = "Application";
      terminal = false;
      startupNotify = true;

      categories = [ "Office" "X-Red-Hat-Base" "X-SuSE-Core-Office" ];
      mimeType = [ "application/vnd.openofficeorg.extension" "x-scheme-handler/vnd.libreoffice.cmis" "x-scheme-handler/vnd.sun.star.webdav" "x-scheme-handler/vnd.sun.star.webdavs" "x-scheme-handler/vnd.libreoffice.command" "x-scheme-handler/ms-word" "x-scheme-handler/ms-powerpoint" "x-scheme-handler/ms-excel" "x-scheme-handler/ms-visio" "x-scheme-handler/ms-access" ];

      actions = {
        "Writer" = {
          name = "Writer";
          exec = "soffice --writer";
        };
        "Calc" = {
          name = "Calc";
          exec = "soffice --calc";
        };
        "Impress" = {
          name = "Impress";
          exec = "soffice --impress";
        };
        "Draw" = {
          name = "Draw";
          exec = "soffice --draw";
        };
        "Base" = {
          name = "Base";
          exec = "soffice --base";
        };
        "Math" = {
          name = "Math";
          exec = "soffice --math";
        };
      };
    };

    xdg.desktopEntries."writer" = {
      name = "LibreOffice Writer";
      genericName = "Word Processor";
      comment = "Create and edit text and graphics in letters, reports, documents and Web pages.";
      icon = "libreoffice-writer";
      noDisplay = true;

      exec = "soffice --writer %U";
      type = "Application";
      terminal = false;
      startupNotify = true;

      categories = [ "Office" "WordProcessor" "X-Red-Hat-Base" ];
      mimeType = [ "application/vnd.oasis.opendocument.text" "application/vnd.oasis.opendocument.text-template" "application/vnd.oasis.opendocument.text-web" "application/vnd.oasis.opendocument.text-master" "application/vnd.oasis.opendocument.text-master-template" "application/vnd.sun.xml.writer" "application/vnd.sun.xml.writer.template" "application/vnd.sun.xml.writer.global" "application/msword" "application/vnd.ms-word" "application/x-doc" "application/x-hwp" "application/rtf" "text/rtf" "application/vnd.wordperfect" "application/wordperfect" "application/vnd.lotus-wordpro" "application/vnd.openxmlformats-officedocument.wordprocessingml.document" "application/vnd.ms-word.document.macroEnabled.12" "application/vnd.openxmlformats-officedocument.wordprocessingml.template" "application/vnd.ms-word.template.macroEnabled.12" "application/vnd.ms-works" "application/vnd.stardivision.writer-global" "application/x-extension-txt" "application/x-t602" "text/plain" "application/vnd.oasis.opendocument.text-flat-xml" "application/x-fictionbook+xml" "application/macwriteii" "application/x-aportisdoc" "application/prs.plucker" "application/vnd.palm" "application/clarisworks" "application/x-sony-bbeb" "application/x-abiword" "application/x-iwork-pages-sffpages" "application/vnd.apple.pages" "application/x-mswrite" "application/x-starwriter" ];

      actions = {
        "NewDocument" = {
          name = "New Document";
          icon = "document-new";
          exec = "soffice --writer";
        };
      };
    };

    xdg.desktopEntries."calc" = {
      name = "LibreOffice Calc";
      genericName = "Spreadsheet";
      comment = "Perform calculations, analyze information and manage lists in spreadsheets.";
      icon = "libreoffice-calc";
      noDisplay = true;

      exec = "soffice --calc %U";
      type = "Application";
      terminal = false;
      startupNotify = true;

      categories = [ "Office" "Spreadsheet" "X-Red-Hat-Base" ];
      mimeType = [ "application/vnd.oasis.opendocument.spreadsheet" "application/vnd.oasis.opendocument.spreadsheet-template" "application/vnd.sun.xml.calc" "application/vnd.sun.xml.calc.template" "application/msexcel" "application/vnd.ms-excel" "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" "application/vnd.ms-excel.sheet.macroEnabled.12" "application/vnd.openxmlformats-officedocument.spreadsheetml.template" "application/vnd.ms-excel.template.macroEnabled.12" "application/vnd.ms-excel.sheet.binary.macroEnabled.12" "text/csv" "application/x-dbf" "text/spreadsheet" "application/csv" "application/excel" "application/tab-separated-values" "application/vnd.lotus-1-2-3" "application/vnd.oasis.opendocument.chart" "application/vnd.oasis.opendocument.chart-template" "application/x-dbase" "application/x-dos_ms_excel" "application/x-excel" "application/x-msexcel" "application/x-ms-excel" "application/x-quattropro" "application/x-123" "text/comma-separated-values" "text/tab-separated-values" "text/x-comma-separated-values" "text/x-csv" "application/vnd.oasis.opendocument.spreadsheet-flat-xml" "application/vnd.ms-works" "application/clarisworks" "application/x-iwork-numbers-sffnumbers" "application/vnd.apple.numbers" "application/x-starcalc" ];

      actions = {
        "NewDocument" = {
          name = "New Spreadsheet";
          icon = "document-new";
          exec = "soffice --calc";
        };
      };
    };

    xdg.desktopEntries."impress" = {
      name = "LibreOffice Impress";
      genericName = "Presentation";
      comment = "Create and edit presentations for slide shows, meetings, Web pages, and training.";
      icon = "libreoffice-impress";
      noDisplay = true;

      exec = "soffice --impress %U";
      type = "Application";
      terminal = false;
      startupNotify = true;

      categories = [ "Office" "Presentation" "X-Red-Hat-Base" ];
      mimeType = [ "application/vnd.oasis.opendocument.presentation" "application/vnd.oasis.opendocument.presentation-template" "application/vnd.sun.xml.impress" "application/vnd.sun.xml.impress.template" "application/mspowerpoint" "application/vnd.ms-powerpoint" "application/vnd.openxmlformats-officedocument.presentationml.presentation" "application/vnd.ms-powerpoint.presentation.macroEnabled.12" "application/vnd.openxmlformats-officedocument.presentationml.template" "application/vnd.ms-powerpoint.template.macroEnabled.12" "application/vnd.openxmlformats-officedocument.presentationml.slide" "application/vnd.openxmlformats-officedocument.presentationml.slideshow" "application/vnd.ms-powerpoint.slideshow.macroEnabled.12" "application/vnd.oasis.opendocument.presentation-flat-xml" "application/x-iwork-keynote-sffkey" "application/vnd.apple.keynote" ];

      actions = {
        "NewDocument" = {
          name = "New Presentation";
          icon = "document-new";
          exec = "soffice --impress";
        };
      };
    };

    xdg.desktopEntries."draw" = {
      name = "LibreOffice Draw";
      genericName = "Drawing";
      comment = "Create and edit drawings, flow charts, and logos.";
      icon = "libreoffice-draw";
      noDisplay = true;

      exec = "soffice --draw %U";
      type = "Application";
      terminal = false;
      startupNotify = true;

      categories = [ "Office" "Graphics" "X-Red-Hat-Base" ];
      mimeType = [ "application/vnd.oasis.opendocument.graphics" "application/vnd.oasis.opendocument.graphics-flat-xml" "application/vnd.oasis.opendocument.graphics-template" "application/vnd.sun.xml.draw" "application/vnd.sun.xml.draw.template" "application/vnd.visio" "application/x-wpg" "application/vnd.corel-draw" "application/vnd.ms-publisher" "image/x-freehand" "application/clarisworks" "application/x-pagemaker" "application/pdf" "application/x-stardraw" "image/x-emf" "image/x-wmf" ];

      actions = {
        "NewDocument" = {
          name = "New Drawing";
          icon = "document-new";
          exec = "soffice --draw";
        };
      };
    };

    xdg.desktopEntries."base" = {
      name = "LibreOffice Base";
      genericName = "Database";
      comment = "Create and manage databases, and prepare forms and reports.";
      icon = "libreoffice-base";
      noDisplay = true;

      exec = "soffice --base %U";
      type = "Application";
      terminal = false;
      startupNotify = true;

      categories = [ "Office" "Database" "X-Red-Hat-Base" ];
      mimeType = [ "application/vnd.oasis.opendocument.base" "application/vnd.sun.xml.base" ];

      actions = {
        "NewDocument" = {
          name = "New Database";
          icon = "document-new";
          exec = "soffice --base";
        };
      };
    };

    xdg.desktopEntries."math" = {
      name = "LibreOffice Math";
      genericName = "Formula Editor";
      comment = "Create and edit mathematical formulas.";
      icon = "libreoffice-math";
      noDisplay = true;

      exec = "soffice --math %U";
      type = "Application";
      terminal = false;
      startupNotify = true;

      categories = [ "Office" "Math" "X-Red-Hat-Base" ];
      mimeType = [ "application/vnd.oasis.opendocument.formula" "application/vnd.sun.xml.math" "application/vnd.oasis.opendocument.formula-template" "text/mathml" "application/mathml+xml" ];

      actions = {
        "NewDocument" = {
          name = "New Formula";
          icon = "document-new";
          exec = "soffice --math";
        };
      };
    };

    xdg.desktopEntries."xsltfilter" = {
      name = "LibreOffice XSLT Filters";
      genericName = "XSLT based filters";
      comment = "Transform XML documents using XSLT stylesheets.";
      noDisplay = true;

      exec = "soffice %U";
      type = "Application";
      terminal = false;
      startupNotify = true;

      mimeType = [ "application/vnd.oasis.opendocument.text-flat-xml" "application/vnd.oasis.opendocument.spreadsheet-flat-xml" "application/vnd.oasis.opendocument.graphics-flat-xml" "application/vnd.oasis.opendocument.presentation-flat-xml" ];
    };

    /* -------------------------------------------------------------------------- */
    /*                                Configuration                               */
    /* -------------------------------------------------------------------------- */

    xdg.configFile."libreoffice/4/user/registrymodifications.xcu" = {
      text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <oor:items xmlns:oor="http://openoffice.org/2001/registry" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

        <item oor:path="/org.openoffice.Office.Common/Misc"><prop oor:name="FirstRun" oor:op="fuse"><value>false</value></prop></item>
        <item oor:path="/org.openoffice.Office.Common/Misc"><prop oor:name="ShowTipOfTheDay" oor:op="fuse"><value>false</value></prop></item>

        <item oor:path="/org.openoffice.Office.UI.ToolbarMode"><prop oor:name="ActiveCalc" oor:op="fuse"><value>notebookbar.ui</value></prop></item>
        <item oor:path="/org.openoffice.Office.UI.ToolbarMode"><prop oor:name="ActiveDraw" oor:op="fuse"><value>notebookbar.ui</value></prop></item>
        <item oor:path="/org.openoffice.Office.UI.ToolbarMode"><prop oor:name="ActiveImpress" oor:op="fuse"><value>notebookbar.ui</value></prop></item>
        <item oor:path="/org.openoffice.Office.UI.ToolbarMode"><prop oor:name="ActiveWriter" oor:op="fuse"><value>notebookbar.ui</value></prop></item>
        <item oor:path="/org.openoffice.Office.UI.ToolbarMode/Applications/org.openoffice.Office.UI.ToolbarMode:Application['Calc']"><prop oor:name="Active" oor:op="fuse"><value>notebookbar.ui</value></prop></item>
        <item oor:path="/org.openoffice.Office.UI.ToolbarMode/Applications/org.openoffice.Office.UI.ToolbarMode:Application['Draw']"><prop oor:name="Active" oor:op="fuse"><value>notebookbar.ui</value></prop></item>
        <item oor:path="/org.openoffice.Office.UI.ToolbarMode/Applications/org.openoffice.Office.UI.ToolbarMode:Application['Impress']"><prop oor:name="Active" oor:op="fuse"><value>notebookbar.ui</value></prop></item>
        <item oor:path="/org.openoffice.Office.UI.ToolbarMode/Applications/org.openoffice.Office.UI.ToolbarMode:Application['Writer']"><prop oor:name="Active" oor:op="fuse"><value>notebookbar.ui</value></prop></item>

        </oor:items>
      '';
      force = true;
    };

    /* -------------------------------------------------------------------------- */
    /*                                 Integration                                */
    /* -------------------------------------------------------------------------- */

    programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite = lib.mkIf config.programs.waybar.enable {
      "libreoffice" = "󱇧";
    };
  };
}
