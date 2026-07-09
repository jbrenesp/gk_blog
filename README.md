Glass Blog 

A full-stack blog platform built with Ruby on Rails. 

This was a personal portfolio project where I built everything from scratch — authentication, user roles, content management, and deployment.

Deployed on Railway:  https://www.butterandstars.com/

Features

User Authentication — Sign up, log in, and log out by the Devise gem

Role-Based Permissions — Admin and Author roles with different levels of access

Full CRUD — Create, read, update, and delete blog posts

Comments — Anyone can leave comments on posts

Likes — Anyone can like posts

Rich Text Editor — Posts support rich text content via Action Text (Trix)

Admin Dashboard — Admins can manage users and content

Contact Page — Visitors can reach out via a contact form

About Page — Static page describing the blog



Tech Stack


Framework	      Ruby on Rails
Authentication	Devise
Frontend	      HTML, CSS, Turbo (Hotwire)
Rich Text	      Action Text / Trix
File Storage	  Active Storage
Database	      PostgreSQL
Deployment	    Render


I learn a lot in this project:
Setting up Devise for authentication and customising its views and flow

Implementing role-based authorisation to restrict actions based on user type

Using Action Text and Active Storage for rich content and file uploads

Debugging — reading error logs, tracing issues in the controller/model layer, and fixing bugs before deployment

Deployment realities — even after thorough local testing, things broke in production.

Learning to diagnose and fix production-only issues was one of the biggest takeaways of this project. 

Learning that the coding part of web development might be the “easy” part was my biggest takeaway of this project. Deploying it and debugging was the hard part. 

Getting Started

Prerequisites
Ruby 3.x
Rails 7.x
PostgreSQL
Setup


bash
# Clone the repo
git clone https://github.com/your-username/glass-blog.git
cd glass-blog

# Install dependencies
bundle install

# Set up the database
rails db:create db:migrate db:seed

# Start the server
rails server
Then visit http://localhost:3000 in your browser.
Environment Variables
Create a .env file in the root with the following:


DATABASE_URL=your_database_url
SECRET_KEY_BASE=your_secret_key

📁 Project Structure


app/
├── controllers/       # Application logic
├── models/            # Data models (User, Post, Comment, Like)
├── views/             # ERB templates
├── assets/
│   └── stylesheets/   # Custom CSS with design tokens
config/
├── routes.rb          # All application routes
db/
└── schema.rb          # Database schema

User Roles


Visitor -->	Read posts, view about/contact pages, like and comment on posts
Author	--> All of the above + create, edit, delete own un-published posts
Admin	  --> Full access — manage all posts and users





Screenshots

<img width="2432" height="1324" alt="image" src="https://github.com/user-attachments/assets/53319865-e99e-40d1-ab1c-b1dd2e26af07" />


<img width="1970" height="1286" alt="image" src="https://github.com/user-attachments/assets/69090572-80b0-4182-8372-ea15f604bc04" />


<img width="2452" height="1392" alt="image" src="https://github.com/user-attachments/assets/03c50854-17e4-42a4-a517-3603060dd62c" />

<img width="2482" height="1354" alt="image" src="https://github.com/user-attachments/assets/aa3f2ffc-5d4a-4885-9cca-863656fa53aa" />






Contributing
This is a personal portfolio project, but feedback and suggestions are always welcome. Feel free to open an issue.

📄 License
This project is open source and available under the MIT License.
