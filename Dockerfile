# Start from the official Ruby image
FROM ruby:3.0.3

# Install Node.js and Yarn (needed for Rails asset compilation)
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn

# Set the working directory
WORKDIR /api-synonyms

# Add the Gemfile and Gemfile.lock to the image
COPY Gemfile /api-synonyms/Gemfile
COPY Gemfile.lock /api-synonyms/Gemfile.lock

# Install gems
RUN bundle install

# Copy the rest of the application into the image
COPY . /api-synonyms

# Expose the port that the Rails server will run on
EXPOSE 3000

# Define the command to start the server
CMD ["rails", "server", "-b", "0.0.0.0"]