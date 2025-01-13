# Setup Guide

## Getting Started with Gyazo API

To use the scripts in this repository, you'll need a Gyazo Access Token. Follow these steps to obtain one:

1. **Prepare Your Email**
   - Have a valid email address ready

2. **Create a Gyazo Account**
   - Visit [Gyazo Signup](https://gyazo.com/signup)
   - Fill out the registration form
   - Note: User registration requires human verification through reCAPTCHA

3. **Review API Documentation**
   - OAuth API documentation is available at [Gyazo API Documentation](https://gyazo.com/api)

4. **Register Your Application**
   - Go to [Gyazo OAuth Applications](https://gyazo.com/oauth/applications)
   - Click the "New Application" button
   - Enter your application details

5. **Generate Access Token**
   - After registering your application
   - Look for the "Your access token" section
   - Click the "Generate" button to create your Access Token

6. **Configure Access Token**
   - Once you have your Access Token:
     - Share it with your system administrator
     - The admin will add it to Devin's Secrets configuration
     - It will be available as the `GYAZO_ACCESS_TOKEN` environment variable

## Using the Access Token

The scripts in this repository require the Access Token to be set as an environment variable:

```bash
export GYAZO_ACCESS_TOKEN="your-access-token-here"
```

**Important**: Never commit your Access Token to version control. Always use environment variables or secure secret management.
