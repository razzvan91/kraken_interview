#problem 5
from kubernetes import client, config

def main():

    config.load_kube_config(config_file="~/.kube/config")

    v1 = client.CoreV1Api()
    pod_list = v1.list_pod_for_all_namespaces(label_selector="app=ltc")
    status_list=[]
    for pod in pod_list.items:
        sts = ("{name}={phase}".format(name=pod.metadata.name, phase=pod.status.phase))
        status_list.append(sts)

    # Simulating we have another pod running
    status_list.append('ltc-1=Running')

    print(status_list)
    running_counter = 0
    for e in status_list:
        if "Running" in e:
            running_counter += 1
    if running_counter < len(status_list):
        print(f'There is an issue with {len(status_list) - running_counter} pod/s')

if __name__ == "__main__":
    main()
