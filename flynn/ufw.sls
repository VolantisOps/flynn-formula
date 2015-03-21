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
  {%- set to_addr = salt['mine.get'](grains['id'], 'network.ip_addrs').items()|first()|first() %}
  {%- set selector = salt['pillar.get']('flynn:ufw:peers_glob', '*') %}
  {%- for server, addrs in salt['mine.get'](selector, 'network.ip_addrs').items() %}
    {%- if server != grains['id'] %}
ufw-flynn-peer-{{address}}:
  ufw.allowed:
    - from_addr: {{address}}
    - to_addr: {{to_addr}}
    - require:
      - pkg: ufw
    {%- endif %}
  {%- endfor %}