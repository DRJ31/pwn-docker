import os

versions = {
    "xenial": "16.04",
    "bionic": "18.04",
    "focal": "20.04",
    "jammy": "22.04"
}

os.system("docker login")

for key in versions.keys():
    current = os.popen('cat Dockerfile | head -n 1 | cut -d ":" -f 2').read().split("\n")[0]
    print("##### Current Build: {} #####".format(key))
    os.system('sed -i "s/{}/{}/g" Dockerfile'.format(current, key))
    os.system("docker build -t dengrenjie31/pwnenv:{} .".format(key))
    os.system("docker tag dengrenjie31/pwnenv:{} dengrenjie31/pwnenv:{}".format(key, versions[key]))
    os.system("docker push dengrenjie31/pwnenv:{}".format(key))
    os.system("docker push dengrenjie31/pwnenv:{}".format(versions[key]))

os.system("docker tag dengrenjie31/pwnenv:focal dengrenjie31/pwnenv")
os.system("docker push dengrenjie31/pwnenv")