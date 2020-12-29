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
})
