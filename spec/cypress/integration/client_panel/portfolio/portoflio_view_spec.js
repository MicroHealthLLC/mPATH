describe('Portoflio Viewer ', function() {
  before(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.appScenario('provide_task_privileges')
    cy.login('client@test.com', 'T3$tClient')
    cy.openPortoflioViewer()
  })
  beforeEach(() => {
    cy.preserveAllCookiesOnce()
  })
  // it('Open Portoflio viewer', function() {
  //   
  //   cy.get("#tab-tasks").should('contain', 'TASKS')
  //   cy.get("#tab-issues").should('contain', 'ISSUES')
  //   cy.get("#tab-risks").should('contain', 'RISKS')
  //   cy.get("#tab-lessons").should('contain', 'LESSONS LEARNED')
  // })

  it('Open Task form', function() {
    cy.get('#portTasks > tbody > tr').its('length').should('be.eq', 8)
    cy.get('#portTasks > tbody > tr').first().contains('Test Project').should('be.visible')
    cy.get('#portTasks > tbody > tr').first().contains('Test Facility 1').should('be.visible')
    cy.get('#portTasks > tbody > tr').first().contains('Test Task 1').should('be.visible')
    cy.get('#portTasks > tbody > tr').first().contains('No Update').should('be.visible')

    cy.get('#portTasks > tbody > tr').first().click()
    cy.get('[data-cy="task_name"]').should('have.value', 'Test Task 1')
    cy.get('[data-cy="task_name"]').clear().type('Test Task 1 - Update').should('have.value', 'Test Task 1 - Update')    
    cy.get('[data-cy="task_description"]').should('have.value', 'Test task 1 description')
    cy.get('[data-cy="facility_tabs"]').within(() => {
      cy.get('span').contains('Assignments').click()
      cy.get('span').contains('Checklist').click()
      cy.get('span').contains('Files & Links').click()
      cy.get('span').contains('Updates').click()
      cy.get('span').contains('Task Info').click()
    })

    cy.get('[data-cy="task_save_btn"]').click()
    cy.get('[data-cy="task_close_btn"]').click({force: true})
    cy.get('#portTasks > tbody > tr').first().contains('Test Task 1 - Update').should('be.visible')

  })

})
