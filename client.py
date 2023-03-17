import requests

url = 'localhost:8080/form'
data = {'text': """
@startuml
!include <C4/C4.puml>
!include <C4/C4_Context.puml>

Boundary("B1", "Upstream") {
 System("UP1", "Upstream01")
 System("UP2", "Upstream02")
 System("UP3", "Upstream03")
 Lay_D("UP1", "UP2")
 Lay_D("UP2", "UP3")
}

System("TARGET", "Target")

Boundary("B2", "Downstream") {
 System("DOWN1", "Downstream01")
 System("DOWN2", "Downstream02")
 Lay_D("DOWN1", "DOWN2")
}
@enduml
"""}

x = requests.post(url, json = myobj)

print(x.text)
