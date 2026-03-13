{ ... }:
{
  i18n.extraLocaleSettings.LC_ADDRESS = "it_IT.UTF-8";
  i18n.extraLocaleSettings.LC_IDENTIFICATION = "it_IT.UTF-8";
  i18n.extraLocaleSettings.LC_MEASUREMENT = "it_IT.UTF-8";
  i18n.extraLocaleSettings.LC_MONETARY = "it_IT.UTF-8";
  i18n.extraLocaleSettings.LC_NAME = "it_IT.UTF-8";
  i18n.extraLocaleSettings.LC_NUMERIC = "it_IT.UTF-8";
  i18n.extraLocaleSettings.LC_PAPER = "it_IT.UTF-8";
  i18n.extraLocaleSettings.LC_TELEPHONE = "it_IT.UTF-8";
  i18n.extraLocaleSettings.LC_TIME = "it_IT.UTF-8";

  services.desktopManager.gnome.enable = true;

  services.displayManager.gdm.enable = true;

  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;
}
