describe('Admin Panel Task Stages', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openTaskStageAP()
  })

  it('Click on Task Stages on tabs open Task Stage information page', function() {
    cy.get('#page_title').contains('Task Stages').should('be.visible')
    cy.get('#index_table_task_stages').should('be.visible')
    cy.get('#index_table_task_stages > tbody > tr').its('length').should('be.eq', 2)
    cy.get('#logout').click()
  })

  it('Open and close new Task Stage form', function() {
    cy.get('.action_item > a').contains('New Task Stage').click()
    cy.get('#page_title').contains('New Task Stage').should('be.visible')
    cy.get('.cancel > a').contains('Cancel').click()
    cy.get('#logout').click()
  })
})
