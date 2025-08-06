FROM ruby:3.3.1

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    npm \
    yarn \
    libyaml-dev \
    libffi-dev \
    libgmp-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install the correct bundler version
RUN gem install bundler -v 2.4.19

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle _2.4.19_ install

# Copy the rest of the application
COPY . .

# Add a script to be executed every time the container starts
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Start the main process
CMD ["rails", "server", "-b", "0.0.0.0"] 