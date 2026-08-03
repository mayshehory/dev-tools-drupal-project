# Dev Tools - Drupal Project

## Team Members

- May Shehory
- Nir Dor
- Tomer Elankry

---

## Project Description

In this project we built a Drupal website using Docker and PostgreSQL.

The website contains a glossary of Linux commands from the Dev Tools course.

We also created Bash scripts that make it easy to create the environment, back up the website, restore it and clean the Docker environment.

---

## Technologies

- Ubuntu
- Docker
- Drupal
- PostgreSQL
- Bash
- Git

---

## Project Files

**setup.sh**

Creates the Docker network, volumes and containers required for the project.

**backup.sh**

Creates a backup of the PostgreSQL database and the Drupal files.

**restore.sh**

Restores the website from the backup files.

**cleanup.sh**

Removes all Docker containers, volumes, images and the Docker network created for the project.

---

## Running the Project

Clone the repository:

```bash
git clone https://github.com/mayshehory/dev-tools-drupal-project.git
```

Enter the project folder:

```bash
cd dev-tools-drupal-project
```

Give execution permission:

```bash
chmod +x *.sh
```

Create the environment:

```bash
./setup.sh
```

Open your browser:

```
http://localhost:8080
```

Restore the website:

```bash
./restore.sh
```

Refresh the browser and the website will be restored with all users and glossary content.

---

## Creating a Backup

To create a new backup run:

```bash
./backup.sh
```

The backup files will be saved in the `backup` folder.

---

## Cleaning the Environment

To remove all Docker resources created by the project run:

```bash
./cleanup.sh
```

---

## Notes

- Docker must be installed before running the project.
- An internet connection is required the first time Docker downloads the images.
- Backup files are stored inside the `backup` folder.
- If changes are made to the website, run `backup.sh` again to create an updated backup.
