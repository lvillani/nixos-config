{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    appcleaner
    coconutbattery
  ];

  homebrew.enable = true;
  homebrew.brews = [ "mas" ];
  homebrew.onActivation.cleanup = "zap";

  networking.applicationFirewall.enable = true;
  networking.applicationFirewall.allowSigned = true;
  networking.applicationFirewall.allowSignedApp = false;

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults.dock.autohide = true;
  system.defaults.dock.autohide-delay = 0.0;
  system.defaults.dock.mru-spaces = false;

  system.defaults.finder._FXSortFoldersFirst = true;
  system.defaults.finder._FXSortFoldersFirstOnDesktop = true;
  system.defaults.finder.FXDefaultSearchScope = "SCcf"; # Search current folder
  system.defaults.finder.FXPreferredViewStyle = "clmv"; # Column view
  system.defaults.finder.NewWindowTarget = "Home"; # Home directory

  system.defaults.CustomSystemPreferences = {
    "com.apple.Safari" = {
      AutoFillCreditCardData = false;
      AutoFillFromAddressBook = false;
      AutoFillMiscellaneousForms = false;
      AutoFillPasswords = false;
      AutoOpenSafeDownloads = false;
      SearchProviderIdentifier = "com.duckduckgo";
      ShowFullURLInSmartSearchField = true;
    };
    "com.apple.TextEdit" = {
      RichText = false;
    };
  };

  system.primaryUser = "user";
}
