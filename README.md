# DevOps-tooling

Note: The GitHub Action for OIDC authentication kept failing with this error message:

`Error: Could not assume role with OIDC: Not authorized to perform sts:AssumeRoleWithWebIdentity`

Then, on further research, I found that as of  `July 15, 2026`, newly created GitHub repositories use an immutable OIDC subject format containing organization and repository IDs.

Instead of using:

`repo:your-org/your-repo:ref:refs/heads/feature-branch`

a newer repository may generate something like:

`repo:your-org@OWNER-ID/your-repo@REPO-ID:ref:refs/heads/feature-branch`, for example:

`repo:your-org@12345678/your-lab-repo@987654321:ref:refs/heads/feature/OIDC`

Repositories created before July 15, 2026 normally continue using the older format unless they opted into the new format.

So, the AWS trust policy will change from:
```
"StringLike": {
  "token.actions.githubusercontent.com:sub": "repo:YOUR-ORG/YOUR-REPO:ref:refs/heads/feature/OIDC"
}
```

to something like this:

```
"StringLike": {
  "token.actions.githubusercontent.com:sub": "repo:YOUR-ORG@12345678/YOUR-REPO@987654321:ref:refs/heads/feature/OIDC"
}
```

The complete Trust then becomes:

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:YOUR-ORG@OWNER-ID/YOUR-REPO@REPO-ID:ref:refs/heads/feature/OIDC"
        }
      }
    }
  ]
}
```

## How to find the GitHub owner and repository IDs

On your CLI, type:

```
curl https://api.github.com/repos/YOUR-ORG/YOUR-REPO
```
And in the response, look for something like this for repository ID:

`"id": 987654321` 

And,

```
"owner": {
    "login": "YOUR-ORG",
    "id": 12345678
}
```
For the owner ID.

