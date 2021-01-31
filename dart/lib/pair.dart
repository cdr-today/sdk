import 'dart:typed_data';
import 'package:bs58/bs58.dart';
import 'package:convert/convert.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart' as ed;

/* Basic pair for user account */
class Pair {
  ed.KeyPair pair;

  /* Generate keypair with the default implementation */
  Pair() : this.pair = ed.generateKey();

  /* Account address */
  String address() {
    return base58.encode(this.pair.publicKey.bytes).toString();
  }

  /**
  * Sign hex and return hex
  *
  * * decode hex string to bytes
  * * Sign the bytes and hex the output bytes
  */
  String sign(Uint8List buf) {
    return hex.encode(ed.sign(this.pair.privateKey, buf));
  }
}
