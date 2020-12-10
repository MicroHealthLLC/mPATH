describe('Sheets Tasks View', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openFacilitySheet()
    cy.get('[data-cy=facility_tabs]').contains('Tasks').should('be.visible').click()
  })

  it('Open Sheets tasks in a facility', function() {
    cy.get('[data-cy=task_sheet_index]').within(() => {
      cy.get('[data-cy=task_total]').contains('Total: 2').should('be.visible')
      cy.get('[data-cy=tasks_table]').should('be.visible')
    })
    cy.logout()
  })

  it('Open and Close task form sheet view', function() {
    cy.get('[data-cy=task_sheet_index]').within(() => {
      cy.get('[data-cy=add_task]').should('be.visible').click({force: true})
    })
    cy.get('[data-cy=task_close_btn]').should('be.visible').click({force: true})
    cy.logout()
  })

  it('Open task from sheet task table', function() {
    cy.get('[data-cy=tasks_table]').within(() => {
      cy.get('tr').eq(1).should('be.visible').click({force: true})
    })
    cy.get('[data-cy=task_name]').should('be.visible')
    cy.get('[data-cy=task_close_btn]').should('be.visible').click({force: true})
    cy.logout()
  })
})
