# Reflection

While working on this assignment, AI helped me quickly identify common security issues in the Dockerfile and CI/CD pipeline, such as hardcoded secrets, use of the `latest` base image, and insecure flags like `--privileged`. It also helped me understand best practices like using GitHub Secrets and adding a vulnerability scan using Trivy.

However, I still had to rely on my own understanding when things didn’t work as expected. For example, even after adding GitHub Secrets, the pipeline failed during Docker login. I had to debug the issue by checking logs, verifying secret names, and correcting how they were referenced in the YAML file. This part required actual troubleshooting rather than just following suggestions.

Another area where I used my judgment was deciding to comment out the deployment step. Since I didn’t have a real server or SSH setup, keeping it would only cause unnecessary failures. Instead, I focused on securing the build and scan stages, which are more critical for this assignment.

AI was helpful as a guide, especially for structuring the fixes and understanding concepts, but it didn’t always give a fully working solution directly. I had to refine and adapt the suggestions to make the pipeline actually run successfully. Overall, this felt closer to a real-world debugging and DevSecOps task rather than just a theoretical exercise.

