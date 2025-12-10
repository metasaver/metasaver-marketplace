# Scope Check Skill Tests

Test prompts for scope-check skill. Expected output format:

```
scope: { targets: [...], references: [...] }
```

## Basic Target Detection

1. Create a shared Button component → targets: [multi-mono], refs: []
2. Fix the login bug in resume-builder → targets: [resume-builder], refs: []
3. Create a new agent for validation → targets: [metasaver-marketplace], refs: []
4. Add a new service to commithub → targets: [rugby-crm], refs: []
5. Update the shared eslint config → targets: [multi-mono], refs: []
6. Fix landing page on metasaver.com → targets: [metasaver-com], refs: []
7. Create a new skill for code review → targets: [metasaver-marketplace], refs: []
8. Add resume download feature → targets: [resume-builder], refs: []
9. Fix commithub dashboard bug → targets: [rugby-crm], refs: []
10. Create an MCP server for notifications → targets: [metasaver-marketplace], refs: []

## Target vs Reference Detection (NEW)

11. Add Applications screen to metasaver-com, look at rugby-crm for patterns → targets: [metasaver-com], refs: [rugby-crm]
12. Fix authentication similar to how resume-builder does it → targets: [CWD], refs: [resume-builder]
13. Standardize error handling in rugby-crm based on metasaver-com patterns → targets: [rugby-crm], refs: [metasaver-com]
14. Check how multi-mono handles shared configs → targets: [CWD], refs: [multi-mono]
15. Update skill format, reference the agent-author skill for patterns → targets: [metasaver-marketplace], refs: []
16. Build new feature following the pattern from resume-builder → targets: [CWD], refs: [resume-builder]

## Multi-Target Detection

17. Sync patterns between multi-mono and metasaver-marketplace → targets: [multi-mono, metasaver-marketplace], refs: []
18. Update both resume-builder and rugby-crm databases → targets: [resume-builder, rugby-crm], refs: []
19. Standardize eslint across all repos → targets: [all], refs: []
20. Audit all repos for security issues → targets: [all], refs: []

## Edge Cases

21. Fix the bug → targets: [CWD], refs: []
22. What is TypeScript? → targets: [CWD], refs: []
23. Fix /home/user/code/resume-builder/src/app.tsx → targets: [resume-builder], refs: []
24. Create backend service for resume-builder based on metasaver-com API patterns → targets: [resume-builder], refs: [metasaver-com]

## Complex Scenarios

25. Update shared component in multi-mono and test in resume-builder → targets: [multi-mono, resume-builder], refs: []
26. Fix agent bug in metasaver-marketplace, check rugby-crm for similar issues → targets: [metasaver-marketplace], refs: [rugby-crm]
27. Security scan across entire codebase → targets: [all], refs: []
28. Create new feature like the one in rugby-crm players page → targets: [CWD], refs: [rugby-crm]
29. Port the auth system from metasaver-com to resume-builder → targets: [resume-builder], refs: [metasaver-com]
30. Fix the scope-check skill in metasaver-marketplace → targets: [metasaver-marketplace], refs: []
