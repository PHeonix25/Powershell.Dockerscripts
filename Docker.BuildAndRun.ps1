# Build the container - replacing "blog:latest" with the image name you want 
docker build . `    # Build everything in this folder (based off the Dockerfile)
    -t `            # Make it belong to you
    blog:latest     # Give it a proper name 

# Once it's built, it's time to run it:
docker run -d `         # Run the image as a daemon
    -p 4000:4000 `     # Open any ports that you require (also required in your Dockerfile) 
    -t `               # Make it belong to you
    blog:latest        # The name of the image that you built above
