# Pusat Oleh-Oleh Docker

This repository contains the backend, frontend, and admin dashboard for an e-commerce platform focused on local products. The project is built using modern technologies and is designed to be easily deployable using Docker.

## Project Overview

The Pusat Oleh-Oleh project is an e-commerce platform that allows users to browse and purchase local products. It consists of three main components:

**Backend** Built with Node.js and Express, it handles API requests, database interactions, and business logic.

**Frontend** A React-based user interface for customers to browse products and place orders.

**Admin Dashboard** A Vite-based application for managing products, orders, and other administrative tasks.

The project uses MongoDB as the database and is fully containerized using Docker for easy deployment.

## Technologies Used

**Backend** = Node.js, Express, MongoDB

**Frontend** = React, React Router, Axios

**Admin Dashboard** = Vite, React, Tailwind CSS

**Database** = MongoDB

**Containerization** = Docker, Docker Compose

**Web Server** = Nginx (for production builds)

## Setup Instructions

```bash
git clone https://github.com/Anemonastrum/pusatoleholeh-docker.git
cd pusatoleholeh-docker
bash ./setup.sh
```
( Please adjust the .env first before running the script )

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
