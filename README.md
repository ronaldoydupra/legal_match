--- HOW TO SETUP JENKINS PIPELINE

Use Terraform IAC to generate AWS Resource 
   1. EC2
   2. S3 Bucket
   3. ALB
      - Pre Requisites VPC, Subnet, IGW, Route Table

 
Creating a Pipeline in Jenkins

1. Open Jenkins Dashboard  
   Go to the Jenkins Dashboard.

2. Create a New Item  
   Click on the `+ New Item` button.

3. Enter Project Name  
   Type the name of your project (e.g., `LG-Exam`) in the `Enter an item name` field.

4. Select Pipeline Type  
   Choose `Multi Branch Pipeline` from the list of options.

5. Click OK  
   Click the `OK` button to proceed.

6. Enter Display Name  
   In the pipeline configuration page, type `LG-Exam` in the `Display Name` field.

7. Add Branch Source  
   Under the `Branch Sources` section, click `Add source`.

8. Select Git  
   From the dropdown menu, select `Git`.

9. Enter Repository URL  
   Type the Git project repository URL: `https://github.com/ronaldoydupra/legal_match.git`.

10. Save Configuration  
    Click the `Save` button to save the pipeline configuration.

11. Test the Pipeline  
    Click on the pipeline name you created (e.g., `LG-Exam`).

12. Select Branch  
    Choose the `main` branch from the branch dropdown.

13. Build with Parameters  
    Click `Build with Parameters`.

14. Check CLEANUP Option  
    Check the `CLEANUP` checkbox. This option will destroy all resources created in AWS later.

15. Start the Build  
    Click the `Build` button to start the pipeline job.

---

 Creating an AWS IAM User and Policy

1. Open AWS IAM Console  
   Go to the AWS Console and navigate to IAM (Identity and Access Management).

2. Create a Policy  
   - Click on `Policies` in the IAM dashboard.
   - Click `Create policy`.
   - Use the policy found at this URL: [iam_policy.json](https://github.com/ronaldoydupra/legal_match/blob/main/iam_policy.json).
   - Save the policy and name it `legalmatch-exam`.

3. Create an IAM User  
   - Click on `Users` in the IAM dashboard.
   - Click `Add user`.
   - Enter the user name `devops`.

4. Attach Policy to User  
   - Select `Attach existing policies directly`.
   - Find and select the `legalmatch-exam` policy.
   - Click `Next: Tags`, then `Next: Review`, and finally `Create user`.

5. Create Access Keys  
   - With the `devops` user selected, go to the `Security credentials` tab.
   - Click `Create access key`.
   - Note the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`. These will be used in Jenkins credentials.

---

 Setting Up Jenkins Credentials

1. Access Jenkins Credentials  
   - Click `Manage Jenkins` from the Jenkins Dashboard.
   - Select `Manage Credentials`.

2. Select Credentials Scope  
   - Choose `Stores scoped to Jenkins` > `System`.

3. Add New Credentials  
   - Click `Global credentials (unrestricted)`.
   - Click `Add Credentials`.

4. Configure AWS Credentials  
   - In the `Kind` dropdown, select `AWS Credentials`.
   - Enter `aws-key-secret` in the `ID` field.
   - Enter the `AWS_ACCESS_KEY_ID` from the `devops` user in the `Access Key ID` field.
   - Enter the `AWS_SECRET_ACCESS_KEY` from the `devops` user in the `Secret Access Key` field.

5. Save the Credentials  
   - Click `OK` to create and save the credentials.
