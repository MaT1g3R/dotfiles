function nuclear-warhead
    find / -name .git | while read d; cd "$(dirname "$d")"; git add -A; git commit -m "last words"; git push --all origin; end
end
