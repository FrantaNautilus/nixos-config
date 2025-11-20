{private, ...}: let
  userv = private.userv;
in {
  programs.git = {
    enable = true;
    settings.user.name = userv.userName;
    settings.user.email = userv.userEmail;
    includes = [
      {
        condition = "gitdir:~/Pers/";
        path = "~/Pers/.gitconfig.inc";
      }
      {
        condition = "gitdir:~/Work/";
        path = "~/Work/.gitconfig.inc";
      }
      {
        condition = "gitdir:~/Fn/";
        path = "~/Fn/.gitconfig.inc";
      }
      {
        condition = private.userv.condition-pers;
        path = "~/Pers/.gitconfig.inc";
      }
      {
        condition = private.userv.condition-work1;
        path = "~/Work/.gitconfig.inc";
      }
      {
        condition = private.userv.condition-work2;
        path = "~/Work/.gitconfig.inc";
      }
      {
        condition = private.userv.condition-fn;
        path = "~/Fn/.gitconfig.inc";
      }
      {
        path = "~/.gitconfig.inc";
      }
    ];
  };

  #TODO write the actual include files.

  programs.lazygit = {
    enable = true;
  };
}
