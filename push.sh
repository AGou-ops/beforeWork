#/bin/sh
cp -rnf post/* /media/agou-ops/UBUNTU_FILES/GitHub\ Workspace/myDocs
git add -A
git commit -m "Update site $(date)"
git push 
