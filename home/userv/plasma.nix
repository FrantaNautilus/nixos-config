{
  pkgs,
  private,
  ...
}: {
  qt.platformTheme.name = "kde6";

  programs.plasma = {
    enable = true;
    input.keyboard = {
      layouts = [{layout = "us";}] ++ private.userv.layoutsExtra;
    };
    # panels = [
    #   {
    #     location = "bottom";
    #     height = 32;
    #     floating = false;
    #     widgets = [
    #       {
    #         kickoff = {
    #           sortAlphabetically = true;
    #           icon = "nix-snowflake-white";
    #         };
    #       }
    #       {
    #         digitalClock = {
    #           calendar = {
    #             firstDayOfWeek = "monday";
    #             plugins = [
    #               "pimevents"
    #             ];
    #           };
    #           time = {
    #             format = "24h";
    #             showSeconds = "onlyInTooltip";
    #           };
    #           date = {
    #             enable = true;
    #             format = "shortDate";
    #             position = "belowTime";
    #           };
    #         };
    #       }
    #       {
    #         systemTray.items = {
    #           # We explicitly show bluetooth and battery
    #           shown = [
    #             "org.kde.plasma.battery"
    #             "org.kde.plasma.volume"
    #           ];
    #           # And explicitly hide networkmanagement and volume
    #           hidden = [
    #             "org.kde.plasma.networkmanagement"
    #             "org.kde.plasma.bluetooth"
    #             "org.kde.plasma.devicenotifier"
    #             "org.kde.plasma.brightness"
    #           ];
    #         };
    #       }
    #       {
    #         pager = {
    #           general = {
    #             showWindowOutlines = false;
    #             showApplicationIconsOnWindowOutlines = false;
    #             showOnlyCurrentScreen = false;
    #             navigationWrapsAround = true;
    #             displayedText = "desktopNumber";
    #             selectingCurrentVirtualDesktop = "showDesktop";
    #           };
    #         };
    #       }
    #       "org.kde.plasma.marginsseparator"
    #       {
    #         iconTasks = {
    #           launchers = [
    #             "applications:org.kde.dolphin.desktop"
    #             "applications:org.kde.konsole.desktop"
    #             "applications:brave-browser.desktop"
    #           ];
    #           iconsOnly = true;
    #           appearance = {
    #             showTooltips = true;
    #             highlightWindows = true;
    #             indicateAudioStreams = true;
    #             fill = true;
    #             rows = {
    #               multirowView = "lowSpace";
    #               maximum = 2;
    #             };
    #             iconSpacing = "small";
    #           };
    #           behavior = {
    #             grouping = {
    #               method = "byProgramName";
    #               clickAction = "cycle";
    #             };
    #             sortingMethod = "manually";
    #             minimizeActiveTaskOnClick = true;
    #             middleClickAction = "newInstance";
    #             wheel = {
    #               switchBetweenTasks = true;
    #               ignoreMinimizedTasks = true;
    #             };
    #           };
    #         };
    #       }
    #       #{
    #       #  panelSpacer = {
    #       #    expanding = true;
    #       #  };
    #       #}
    #       {
    #         appMenu = {
    #           compactView = false;
    #         };
    #       }
    #       {
    #         name = "com.github.antroids.application-title-bar";
    #         config = {
    #           Appearance = {
    #             widgetElements = [
    #               "windowIcon"
    #               "windowMinimizeButton"
    #               "windowMaximizeButton"
    #               "windowCloseButton"
    #             ];
    #           };
    #         };
    #       }
    #     ];
    #   }
    # ];
    # window-rules = [
    #   {
    #     description = "Hide title bar";
    #     match = {
    #       window-class = {
    #         value = "*";
    #         type = "substring";
    #       };
    #       window-types = ["normal"];
    #     };
    #     apply = {
    #       noborder = {
    #         value = true;
    #         apply = "force";
    #       };
    #       # `apply` defaults to "apply-initially"
    #       #maximizehoriz = true;
    #       #maximizevert = true;
    #     };
    #   }
    # ];
    # kwin = {
    #   edgeBarrier = 0; # Disables the edge-barriers introduced in plasma 6.1
    #   cornerBarrier = false;
    #   #scripts.polonium.enable = true;
    # };
    configFile = {
      baloofilerc."Basic Settings"."Indexing-Enabled" = false;
      #kwinrc."org.kde.kdecoration2".ButtonsOnLeft = "SF";
      kwinrc = {
        Desktops = {
          Number = {
            value = 4;
            immutable = true;
          };
          Rows = {
            value = 2;
            immutable = true;
          };
        };
        TabBox.LayoutName = "compact";
      };

      #kscreenlockerrc = {
      #  Greeter.WallpaperPlugin = "org.kde.potd";
      #  # To use nested groups use / as a separator. In the below example,
      #  # Provider will be added to [Greeter][Wallpaper][org.kde.potd][General].
      #  "Greeter/Wallpaper/org.kde.potd/General".Provider = "bing";
      #};
    };
  };
}
