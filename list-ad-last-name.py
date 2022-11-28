# Exemple d’un script Python permettant de lister les noms de famille (attribut “sn” des personnes dans l’OU “utilisateurs” du domaine l3-1.lab

import ldap 
server_ip = <YOUR SERVER IP>
serter_port = 389
conn = ldap.initialize("ldap:”+server_ip+”:”+server_port) conn.simple_bind_s("administrator@l3-1.lab", "Passw0rd") 

base_dn = 'ou=utilisateurs,dc=l3-1,dc=lab'
filter = '(objectclass=person)'
attrs = ['sn']
con.search_s( base_dn, ldap.SCOPE_SUBTREE, filter, attrs )
