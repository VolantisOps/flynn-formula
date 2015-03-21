{% from "flynn/map.jinja" import flynn as flynn_map with context %}
{% set flynn_ufw = pillar.get('flynn:ufw', {}) -%}

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
  {%- for address, peer_details in flynn_ufw.get('peers', []) %}
    {%- set to_addr = salt['mine.get'](grains['id'], 'network.ip_addrs')| first %}
    {%- if to_addr != address %}
ufw-flynn-peer-{{address}}:
  ufw.allowed:
    - from_addr: {{address}}
    - to_addr: {{to_addr}}
    - require:
      - pkg: ufw
    {%- endif %}
  {%- endfor %}