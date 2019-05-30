package;

import networking.Network;
import networking.utils.NetworkEvent;
import networking.utils.NetworkMode;
import openfl.display.Sprite;

class Server extends Sprite {
  public function new() {
    super();
    run();
  }

  private function run() {
    var server = Network.registerSession(NetworkMode.SERVER, 
    { ip: '0.0.0.0', port: 8888, flash_policy_file_port: 9999 });

    server.addEventListener(NetworkEvent.CONNECTED, function(event: NetworkEvent) {
      event.client.send({ x: 10});
    });

    server.addEventListener(NetworkEvent.MESSAGE_RECEIVED, function(event: NetworkEvent) {
      server.send({ x: 12});
    });
    server.start();
  }
}