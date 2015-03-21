{% from "flynn/map.jinja" import flynn as flynn_map with context %}

ufw-flynn-http:
  ufw.allowed:
    - protocol: tcp
    - to_port: http
    - require:
      - pkg: ufw

ufw-flynn-https:
  ufw.allowed:
    - protocol: tcp
    - to_port: https
    - require:
      - pkg: ufw

ufw-flynn-git-ssh:
  ufw.allowed:
    - protocol: tcp
    - to_port: "2222"
    - require:
      - pkg: ufw

ufw-flynn-user-ports:
  ufw.allowed:
    - protocol: tcp
    - to_port: "3000:3500"
    - require:
      - pkg: ufw

  # Flynn peers
  {%- set to_addr = salt['mine.get'](grains['id'], 'network.ip_addrs')[grains['id']]|first() %}
  {%- set selector = salt['pillar.get']('flynn:ufw:peers_glob', '*') %}
  {%- for host, addrs in salt['mine.get'](selector, 'network.ip_addrs').items() %}
    {%- if host != grains['id'] %}
ufw-flynn-peer-{{ host }}-{{ addrs|first() }}-to-{{ to_addr }}:
  ufw.allowed:
    - from_addr: {{ addrs|first() }}
    - to_addr: {{ to_addr }}
    - require:
      - pkg: ufw
    {%- endif %}
  {%- endfor %}