describe('Portoflio Viewer ', function() {
  before(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.appScenario('provide_all_privileges')
    cy.login('client@test.com', 'T3$tClient')
    cy.openPortoflioViewer()
  })
  beforeEach(() => {
    cy.preserveAllCookiesOnce()
  })
  it('Open Portoflio viewer', function() {
    
    cy.get("#tab-tasks").should('contain', 'TASKS')
    cy.get("#tab-issues").should('contain', 'ISSUES')
    cy.get("#tab-risks").should('contain', 'RISKS')
    cy.get("#tab-lessons").should('contain', 'LESSONS LEARNED')
  })

  it('Open Task form and Save task', function() {
    cy.get('#portTasks > tbody > tr').its('length').should('be.eq', 8)
    cy.get('#portTasks > tbody > tr').first().contains('Test Project').should('be.visible')
    cy.get('#portTasks > tbody > tr').first().contains('Test Facility 1').should('be.visible')
    cy.get('#portTasks > tbody > tr').first().contains('New Task 1').should('be.visible')
    cy.get('#portTasks > tbody > tr').first().contains('No Update').should('be.visible')

    cy.get('#portTasks > tbody > tr').first().click()
    cy.get('[data-cy="task_name"]').should('have.value', 'New Task 1')
    cy.get('[data-cy="task_name"]').clear().type('1 New Task 1 - Update').should('have.value', '1 New Task 1 - Update')    
    cy.get('[data-cy="task_description"]').should('have.value', 'New task 1 description')
    cy.get('[data-cy="facility_tabs"]').within(() => {
      cy.get('span').contains('Assignments').click()
      cy.get('span').contains('Checklist').click()
      cy.get('span').contains('Files & Links').click()
      cy.get('span').contains('Updates').click()
      cy.get('span').contains('Task Info').click()
    })

    cy.get('[data-cy="task_save_btn"]').click()
    cy.get('[data-cy="task_close_btn"]').click({force: true})
    cy.get('#portTasks > tbody > tr').first().contains('1 New Task 1 - Update').should('be.visible')

  })

  it('Open Issue form and Save issue', function() {
    cy.get("#tab-issues").click()

    cy.get('#portIssues > tbody > tr').its('length').should('be.eq', 8)
    cy.get('#portIssues > tbody > tr').first().contains('Test Project').should('be.visible')
    cy.get('#portIssues > tbody > tr').first().contains('Test Facility 1').should('be.visible')
    cy.get('#portIssues > tbody > tr').first().contains('Test Issue 1').should('be.visible')
    cy.get('#portIssues > tbody > tr').first().contains('No Update').should('be.visible')

    cy.get('#portIssues > tbody > tr').first().click()
    cy.get('[data-cy="issue_title"]').should('have.value', 'Test Issue 1')
    cy.get('[data-cy="issue_title"]').clear().type('Test Issue 1 - Update').should('have.value', 'Test Issue 1 - Update')    
    cy.get('[data-cy="issue_description"]').should('have.value', 'Test issue 1 description')
    cy.get('[data-cy="facility_tabs"]').within(() => {
      cy.get('span').contains('Assignments').click()
      cy.get('span').contains('Checklist').click()
      cy.get('span').contains('Files & Links').click()
      cy.get('span').contains('Updates').click()
    })

    cy.get('[data-cy="issue_save_btn"]').click()
    cy.get('[data-cy="issue_close_btn"]').click({force: true})
    cy.get('#portIssues > tbody > tr').first().contains('Test Issue 1 - Update').should('be.visible')

  })

  it('Open Risk form and Save Risk', function() {
    cy.get("#tab-risks").click()

    cy.get('#portRisks > tbody > tr').its('length').should('be.eq', 8)
    cy.get('#portRisks > tbody > tr').first().contains('Test Project').should('be.visible')
    cy.get('#portRisks > tbody > tr').first().contains('Test Facility 1').should('be.visible')
    cy.get('#portRisks > tbody > tr').first().contains('New Risk 1').should('be.visible')
    cy.get('#portRisks > tbody > tr').first().contains('No Update').should('be.visible')

    cy.get('#portRisks > tbody > tr').first().click()
    cy.get('[data-cy="risk_name"]').should('have.value', 'New Risk 1')
    cy.get('[data-cy="risk_name"]').clear().type('1 New Risk 1 - Update').should('have.value', '1 New Risk 1 - Update')    
    cy.get('[data-cy="risk_description"]').should('have.value', 'New Risk 1 description')
    cy.get('[data-cy="facility_tabs"]').within(() => {
      cy.get('span').contains('Assign').click()
      cy.get('span').contains('Prioritize').click()
      cy.get('span').contains('Control').click()
      cy.get('span').contains('Files & Links').click()
      cy.get('span').contains('Updates').click()
      cy.get('span').contains('Disposition').click()
    })

    cy.get('[data-cy="risk_save_btn"]').click()
    cy.get('[data-cy="risk_close_btn"]').click({force: true})
    cy.get('#portRisks > tbody > tr').first().contains('1 New Risk 1 - Update').should('be.visible')

  })

  it('Open Lesson form and Save Lesson', function() {
    cy.get("#tab-lessons").click()

    cy.get('#portLessons > tbody > tr').its('length').should('be.eq', 4)
    cy.get('#portLessons > tbody > tr').first().contains('Test Project').should('be.visible')
    cy.get('#portLessons > tbody > tr').first().contains('Test Facility 1').should('be.visible')
    cy.get('#portLessons > tbody > tr').first().contains('Test Lesson 1').should('be.visible')
    cy.get('#portLessons > tbody > tr').first().contains('No Update').should('be.visible')

    cy.get('#portLessons > tbody > tr').first().click()
    cy.get('[data-cy="lesson_name"]').should('have.value', 'Test Lesson 1')
    cy.get('[data-cy="lesson_name"]').clear().type('Test Lesson 1 - Update').should('have.value', 'Test Lesson 1 - Update')    
    cy.get('[data-cy="lesson_description"]').clear().type('Test Lesson 1 description - Update').should('have.value', 'Test Lesson 1 description - Update')
    cy.get('[data-cy="facility_tabs"]').within(() => {
      cy.get('span').contains('Lesson Info').click()
      cy.get('span').contains('Successes').click()
      cy.get('span').contains('Failures').click()
      cy.get('span').contains('Best Practices').click()
      cy.get('span').contains('Files & Links').click()
      cy.get('span').contains('Updates').click()
    })

    cy.get('[data-cy="lesson_save_btn"]').click()
    cy.get('[data-cy="lesson_close_btn"]').click({force: true})
    cy.get('#portLessons > tbody > tr').first().contains('Test Lesson 1 - Update').should('be.visible')

  })

})
