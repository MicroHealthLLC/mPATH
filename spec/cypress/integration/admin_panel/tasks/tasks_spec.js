describe('Admin Panel Task', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openTaskAP()
  })

  it('Click on Tasks on tabs open Task information page', function() {
    cy.get('#page_title').contains('Tasks').should('be.visible')
    cy.get('#index_table_tasks').should('be.visible')
    cy.get('#index_table_tasks > tbody > tr').its('length').should('be.eq', 6)
    cy.get('#logout').click()
  })

  it('Open and close new Task form', function() {
    cy.get('.action_item > a').contains('New Task').click()
    cy.get('#page_title').contains('New Task').should('be.visible')
    cy.get('.cancel > a').contains('Cancel').click()
    cy.get('#logout').click()
  })
})
