describe('Admin Panel Risk Milestones', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.get('[data-cy=admin_panel]').click()
  })

  it('Click on Risk Milestones on tabs open Risk Milestone information page', function() {
    cy.get('#tabs').within(() => {
      cy.get('#risk_milestones').contains('Risk Milestones').click({force: true})
    })
    cy.get('#page_title').contains('Risk Milestones').should('be.visible')
    // cy.get('#index_table_risk_milestones').should('be.visible')
    cy.get('#logout').click()
  })
})
