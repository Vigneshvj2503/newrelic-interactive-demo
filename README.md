New Relic Interactive Demo
Prerequisites
Before deploying the New Relic Interactive Demo on your Kubernetes cluster, ensure you have the following prerequisites in place:

Kubernetes Cluster: You need access to a running Kubernetes cluster.

Need an AWS EKS cluster?

Use the AWS Quick Start: AWS Quick Start for EKS
Or follow this tutorial: Getting Started with Amazon EKS
Deploying the Demo Game
Deploy the Demo Game to the Kubernetes Cluster
Open a terminal or command prompt.

Navigate to the directory containing your Kubernetes configuration files (e.g., game.yaml).

Deploy the demo game to your Kubernetes cluster by running the following command:

bash
Copy code
kubectl create -f game.yaml
Wait for the deployment to complete. You can monitor progress with:

bash
Copy code
kubectl get pods -n default
Once the deployment is complete, check where the service is running by executing:

bash
Copy code
kubectl describe service game-frontend
Copy the LoadBalancer Ingress address and paste it into your web browser to access and try out the demo game.

Deploying New Relic
To monitor and analyze your Kubernetes cluster effectively, you'll need to deploy New Relic components and configure them.

Install kube-state-metrics
Kube-state-metrics is a necessary component for New Relic's Kubernetes integration. It collects valuable cluster information.

Open a terminal or command prompt.

Follow the instructions here to install kube-state-metrics.

Add Your New Relic License Key
Your New Relic license key is required for authentication. Store it securely in a Kubernetes secret.

Open a terminal or command prompt.

Run the following command, replacing <YOUR_LICENSE_KEY> with your actual New Relic license key:

bash
Copy code
kubectl create secret generic newrelic-secret --from-literal=new_relic_license_key='<YOUR_LICENSE_KEY>'
Install New Relic Metadata Injection
Metadata injection enriches your application's telemetry data with Kubernetes metadata. Follow these steps to install it:

Open a terminal or command prompt.

Apply the configuration by running the following command:

bash
Copy code
kubectl apply -f k8s-metadata-injection-latest.yaml
If you're using specific Kubernetes distributions like EKS, additional steps are required:

Go to the EKS page of your cluster and copy the value in the Certificate authority field.

Run the following command in your terminal, replacing <PASTE_CERTIFICATE_AUTHORITY> with the copied value:

bash
Copy code
caBundle=<PASTE_CERTIFICATE_AUTHORITY>
kubectl patch mutatingwebhookconfiguration newrelic-metadata-injection-cfg --type='json' -p "[{'op': 'replace', 'path': '/webhooks/0/clientConfig/caBundle', 'value':'${caBundle}'}]"
Install New Relic Kubernetes Integration
The Kubernetes integration collects and sends Kubernetes cluster data to New Relic for analysis.

Open a terminal or command prompt.

Deploy New Relic Kubernetes integration with this command:

bash
Copy code
kubectl create -f newrelic-infrastructure-k8s-latest.yaml
Verify that the newrelic-infra daemonset and pods are running:

bash
Copy code
kubectl get daemonsets
kubectl get pods
Horizontal Pod Autoscaling (HPA)
Horizontal Pod Autoscaling (HPA) automatically adjusts the number of pods in a deployment based on CPU utilization.

Install Metrics-Server
Metrics-Server is a prerequisite for HPA and helps determine when to scale pods. If you don't already have Metrics-Server installed, follow these steps:

Open a terminal or command prompt.

Ensure Helm is installed on your cluster by following these instructions.

Install Metrics-Server using Helm with this command:

bash
Copy code
helm install stable/metrics-server --name metrics-server --version 2.0.4 --namespace metrics
Configure Autoscaling
Open a terminal or command prompt.

Configure HPA for the game-frontend deployment to scale based on CPU usage, targeting 50% CPU utilization:

bash
Copy code
kubectl autoscale deployment game-frontend --cpu-percent=50 --min=1 --max=10
Check Horizontal Pod Autoscaler
Monitor the HPA to observe its behavior:

bash
Copy code
kubectl get hpa --watch
Clean-Up
If you need to clean up the deployed resources, you can use the following commands:

bash
Copy code
kubectl delete -f game.yaml
kubectl delete -f kube-state-metrics-release-1.5/kubernetes/
kubectl delete -f newrelic-infrastructure-k8s-latest.yaml
kubectl delete hpa game-frontend
kubectl delete secret newrelic-secret
This revised README provides a step-by-step guide for deploying the New Relic Interactive Demo, deploying New Relic components, enabling HPA, and important notes for beginners to ensure a successful deployment.
