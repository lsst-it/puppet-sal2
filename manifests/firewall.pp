# @summary Setup firewall exceptions for SAL components
#
# Setup firewall exceptions for SAL components.
#
# See also:
# - https://gist.github.com/juliojsb/00e3bb086fd4e0472dbe
# - https://community.rti.com/content/forum-topic/statically-configure-firewall-let-omg-dds-traffic-through
# - https://github.com/lsst-ts/ts_sal/blob/develop/lsstsal/doc/SAL_User_Guide.pdf
#
# @param multicast_cidr
#   Allow all multicast traffic from/to this address.
#
#   Default value: `127.0.0.1/32`
#
# @param omgdds_ports
#   UDP port ranges to open for omg dds.
#   Values must be strings that are valid format for iptables.
#
#   Default values:
#   - `7400-32399`
#   - `32768-65535`
#
# @param omgdds_subnets
#   Allow incoming OMG DDS multicast/unicast input from these IP's/masks/CIDR's.
#   Values must be strings that are valid iptables source masks.
#
#   Default values:
#   - `127.0.0.1/32`
#
# @param opensplice_ports
#   UDP port ranges to open for opensplice.
#   Values must be strings that are valid format for iptables.
#
#   Default values:
#   - `250-251`
#
# @param opensplice_subnets
#   Allow incoming OpenSplice traffic from these IP's/masks/CIDR's.
#   Values must be strings that are valid iptables source masks.
#
#   Default values:
#   - `127.0.0.1/32`
#
# @example
#   include sal2::firewall
class sal2::firewall (
  String[9]          $multicast_cidr,
  Array[String[1],1] $omgdds_ports,
  Array[String[1],1] $omgdds_subnets,
  Array[String[1],1] $opensplice_ports,
  Array[String[1],1] $opensplice_subnets,
) {


  # Configure Multicast/Unicast
  firewall {
    "501 ${module_name} - allow multicast INPUT from ${multicast_cidr}":
      chain  => 'INPUT',
      source => $multicast_cidr,
    ;
    "501 ${module_name} - allow multicast FORWARD from/to ${multicast_cidr}":
      chain       => 'FORWARD',
      source      => $multicast_cidr,
      destination => $multicast_cidr,
    ;
    "501 ${module_name} - allow multicast OUTPUT to ${multicast_cidr}":
      chain       => 'OUTPUT',
      destination => $multicast_cidr,
    ;
    default:
      proto  => all,
      action => 'accept',
  }

  $omgdds_subnets.each | $source_cidr |
  {
    firewall { "501 ${module_name} - allow OMG DDS multicast/unicast from ${source_cidr}":
      chain  => 'INPUT',
      proto  => 'udp',
      dport  => $omgdds_ports,
      source => $source_cidr,
      action => 'accept',
    }
  }

  $opensplice_subnets.each | $source_cidr |
  {
    firewall { "501 ${module_name} - allow SAL OpenSlice from ${source_cidr}":
      chain  => 'INPUT',
      proto  => 'udp',
      dport  => $opensplice_ports,
      source => $source_cidr,
      action => 'accept',
    }
  }

}
