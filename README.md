# Traffic Shock Wave Propagation Parameters
A [MATLAB & Simulink](https://www.mathworks.com/products/matlab.html) program and model developed for MAS354 Modelling and Simulation at Murdoch University which seeks to identify the optimal vehicle speeds and driver behaviour to avoid shockwave generation and, therefore, the costs associated with the inefficient transit of the road section. At this stage, we seek to identify a relationship between road conditions and driver behaviours and the threshold values of the driver behaviour parameters that avoid the development of a traffic shock wave.

To run the CA code to generate a plot of vehicle positions modify the values of the parameters in the RunCellularAutomataV2.m and run it.
To run a parameter/output search, modify the parameters in the run_parameter_search.m and run it.

# Development Workflow
In short:
  1. Start a new feature branch for each set of edits that you do. See below.
  2. Cut some code! See below.
  3. When finished, push your feature branch to the repository, and create a pull request.

You should ensure that you have [MATLAB & Simulink](https://www.mathworks.com/products/matlab.html) and [Git](https://git-scm.com/) installed, and that you have setup a [GitHub](https://github.com/) account. If you are going to clone over SSH, ensure that you are familiar with [adding a new SSH key to your GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

## Configuring the Repository
Firstly, in a terminal, clone this repository locally:
```
git clone https://github.com/jdilanzo/tshock.git
```

In a terminal, introduce yourself to [Git](https://git-scm.com/) (using the same email you have used to setup your [GitHub](https://github.com/) account):
```
git config --global user.email you@yourdomain.com
git config --global user.name "Your Name"
```
You can omit the `--global` switch if you only want to configure your email and name for the current repository.

## Creating a New Feature Branch
In the repository root directory, ensure you are on the main branch and pull in any recent changes:
```
git checkout main
git pull origin main
```
Then, create a new branch based on the main branch:
```
git checkout -b new-feature-branch-name
```

## Editing and Committing
In short, make some changes and then commit those changes using the following workflow:
  1. Optional: Check which files have been changed.
  2. Optional: Compare changes with the previous version.
  3. Add relevant modified files to the staging area.
  4. Commit the staged files to the local repository.
  5. Push local changes to the remote repository.

The commands used to achieve this basic workflow are (in order):
```
git status
git diff
git add modified_filename
git commit -m "Some commit message"
git push origin new-feature-branch-name
```

Commit messages should be clear, concise, and briefly overview the what and the why of the modification. When you feel your work is finished, you can create a pull request via the [GitHub](https://github.com/) web interface so that all the changes in your feature branch can be merged into the main branch.
