describe('Apply filters in Map Page', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openMap()
  })

  it('Open and close filters tab', function() {
    cy.toggleFilterTab()
    cy.get('[data-cy=filter_info]').within(() => {
      cy.contains('FILTER VIEW').should('be.visible')
      cy.get('[data-cy=clear_filter]').contains('CLEAR').should('be.visible')
      cy.contains('Facilities').should('be.visible')
    })
    cy.toggleFilterTab()
    cy.logout()
  })

  it('Apply filter on active project status', function() {
    cy.toggleFilterTab()
    cy.get('[data-cy=filter_bar]').within(() => {
      cy.get('[data-cy=project_status]').as('list')
      cy.get('@list').click()
      cy.get('@list').within(() => {
        cy.contains('Active').click()
      })
    })
    cy.toggleFilterTab()
    cy.activeProjectStatus()
    cy.logout()
  })

  it('Apply filter on inactive project status', function() {
    cy.toggleFilterTab()
    cy.get('[data-cy=filter_bar]').within(() => {
      cy.get('[data-cy=project_status]').as('list')
      cy.get('@list').click()
      cy.get('@list').within(() => {
        cy.contains('InActive').click()
      })
    })
    cy.toggleFilterTab()
    cy.inActiveProjectStatus()
    cy.logout()
  })
})
