# Security Audit Report

## Overview

I was given a Dockerfile and a CI/CD pipeline which were working, but had multiple security and reliability issues. My goal was to review them, identify problems, and fix them in a practical way without changing the application itself.

---

## Dockerfile Issues & Fixes

### 1. Using `node:latest`

The base image was set to `latest`. This is risky because the version can change anytime and might break the app or introduce vulnerabilities.

I changed it to a specific version (`node:18-alpine`) so that the build is stable and predictable. Also, alpine is smaller and reduces the attack surface.

---

### 2. Copying everything too early

The Dockerfile was copying the entire project before installing dependencies.

This affects caching and makes builds slower because even small changes force reinstalling everything.

I changed the order to copy only `package.json` first, install dependencies, and then copy the rest.

---

### 3. Hardcoded secrets

There were secrets like `SECRET_KEY` and `DB_PASSWORD` inside the Dockerfile.

This is a big issue because once the image is built, anyone with access to it can see those values.

I removed them completely. These should be passed at runtime using environment variables or secret managers.

---

### 4. Installing unnecessary tools

Packages like curl, vim, and wget were installed.

They are not needed for running the app and only increase the attack surface.

So I removed them to keep the image minimal.

---

### 5. Exposing port 22

Port 22 (SSH) was exposed, which is not needed for a Node.js app.

I removed it and only kept port 3000.

---

### 6. Running as root

By default, the container runs as root, which is not safe.

I added a non-root user and switched to it. This reduces the impact if something goes wrong.

---

## CI/CD Pipeline Issues & Fixes

### 1. Hardcoded credentials

Docker and AWS credentials were directly written in the pipeline file.

This is dangerous because anyone with repo access can see them.

I moved them to GitHub Secrets so they are not exposed in code.

---

### 2. No vulnerability scanning

There was no step to check if the Docker image has known vulnerabilities.

I added a Trivy scan after the image build. The pipeline now fails if any CRITICAL issues are found.

This prevents insecure images from reaching production.

---

### 3. Insecure Docker push

The image was not properly tagged with a Docker Hub username.

I fixed it to use `myuser/myapp:latest` so it works correctly with Docker Hub.

---

### 4. Use of `--privileged`

The container was being run with `--privileged`.

This gives the container full access to the host, which is risky.

I removed it. The container should only have the permissions it actually needs.

---

### 5. SSH host key checking disabled

`StrictHostKeyChecking=no` was used during SSH.

This makes it easier for man-in-the-middle attacks.

I removed it to keep SSH verification intact.

---

## Decision Questions

### Q1 — Vulnerability management

If updating the base image breaks the app, I wouldn’t immediately force the upgrade.

I would first check how serious the risk is in our setup. If it’s not directly exploitable, I would apply temporary controls like limiting network access or monitoring closely.

At the same time, I would inform the team about the risk and plan a proper fix. So basically, mitigate now and fix properly soon.

---

### Q2 — Container security

Even if the service is internal, using `--privileged` is still risky.

If the container gets compromised, it can affect the host system. Internal access doesn’t mean safe, especially in real-world environments.

So I would avoid it and use only required permissions.

---

### Q3 — Git history & secrets

Removing secrets from the current code is not enough.

They still exist in the Git history. Anyone can check old commits and find them.

So we need to clean the history and rotate the credentials. Both steps are important.

---

### Q4 — Trade-off reasoning

Pinning versions improves security, but makes updates harder.

I would use a balanced approach — pin versions but review and update them regularly.

This way we get both security and maintainability.

---

## Final Thoughts

The main focus was to reduce risk without overcomplicating things. I tried to keep the setup simple, secure, and practical for real use.
