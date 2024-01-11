(import ./lib.nix) {
  name = "from-nixos";
  nodes = {
    # self here is set by using specialArgs in `lib.nix`
    node1 = { self, pkgs, ... }: {
      imports = [ self.nixosModules.hello-world-server ];
      environment.systemPackages = [ pkgs.curl ];
    };
  };
  # This is the test code that will check if our service is running correctly:
  testScript = ''
    start_all()
    # wait for our service to start
    node1.wait_for_unit("hello-world-server")
    node1.wait_for_open_port(8000)
    output = node1.succeed("curl localhost:8000/index.html")
    # Check if our webserver returns the expected result
    assert "Hello world" in output, f"'{output}' does not contain 'Hello world'"
  '';
}
