"""
Note: we ended up not using OAuth2 in the production environment,
due to multiple issues:
- Servers can be shared between all users, but saved passwords don't get shared.
- OAuth2 users need to provide an additional "Master password" to be able to save passwords
  across server restarts, which goes against the whole point of having Single Sign-On in the first place.
- The `OAUTH2_AUTO_CREATE_USER` option doesn't work, any MS365 user can create an account.
"""

"""
# Enable authentication with OAuth2,
# besides internal authentication with username and password.
AUTHENTICATION_SOURCES = ['oauth2', 'internal']

# Configuration based on https://www.pgadmin.org/docs/pgadmin4/latest/oauth2.html
OAUTH2_CONFIG = [
    {
        # Name of the OAuth2 provider.
        'OAUTH2_NAME': 'Microsoft365',
        # Human readable name of the OAuth2 provider, as displayed in the web interface.
        'OAUTH2_DISPLAY_NAME': 'Microsoft 365',
        # Client ID for the corresponding app registration.
        'OAUTH2_CLIENT_ID': '<client ID>',
        # Client secret.
        'OAUTH2_CLIENT_SECRET': '<client secret>',
        # URL for retrieving user tokens.
        'OAUTH2_TOKEN_URL': 'https://login.microsoftonline.com/08a1a72f-fecd-4dae-8cec-471a2fb7c2f1/oauth2/v2.0/token',
        # URL for authorizing requests.
        'OAUTH2_AUTHORIZATION_URL': 'https://login.microsoftonline.com/08a1a72f-fecd-4dae-8cec-471a2fb7c2f1/oauth2/v2.0/authorize',
        # URL for retrieving server metadata.
        'OAUTH2_SERVER_METADATA_URL': 'https://login.microsoftonline.com/08a1a72f-fecd-4dae-8cec-471a2fb7c2f1/v2.0/.well-known/openid-configuration',
        # Base URL for provider API.
        'OAUTH2_API_BASE_URL': 'https://graph.microsoft.com/',
        # Endpoint for retrieving user data.
        'OAUTH2_USERINFO_ENDPOINT': 'oidc/userinfo',
        # Scopes to request upon authentication.
        'OAUTH2_SCOPE': 'openid email',
        # Font-Awesome icon to be placed on the corresponding login button.
        'OAUTH2_ICON': 'fa-microsoft',
        # Login button color.
        # 'OAUTH2_BUTTON_COLOR': '',
        # Claim for retrieving username. We use the app-specific unique ID of the user.
        'OAUTH2_USERNAME_CLAIM': 'sub',
        # Don't create new user accounts automatically upon the first login,
        # require them to have been created previously by an admin.
        'OAUTH2_AUTO_CREATE_USER': False,
    }
]
"""
