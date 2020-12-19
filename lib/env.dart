enum BuildFlavor { dev, release }

class BuildEnvironment {
  final BuildFlavor flavor;
  final String apiBaseUrl;

  BuildEnvironment.dev({
    this.apiBaseUrl,
  }) : this.flavor = BuildFlavor.dev;

  BuildEnvironment.release({
    this.apiBaseUrl,
  }) : this.flavor = BuildFlavor.release;
}
