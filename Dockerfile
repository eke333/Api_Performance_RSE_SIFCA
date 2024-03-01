# Use the official Python image as a base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the dependencies file to the working directory
COPY . .

# Install Flask and other dependencies
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 4535

# Define the command to run the application
CMD ["python", "app.py"]
