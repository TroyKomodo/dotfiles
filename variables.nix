{
  username = "troy";
  git = {
    fullName = "Troy Benson";
    email = "me@troymoder.dev";
  };
  sshKeyPub = builtins.readFile ./static/ssh-key.pub;
  wallpaper = ./static/wallpaper.jpg;
  profilePicture = ./static/pfp.jpg;
}
