describe('On watch task details', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openOnWatch()
  })

  it('Open On Watch tasks to display watched tasks', function() {
    cy.get('[data-cy=watch_view]').within(() => {
      cy.get('[data-cy=watched_task_status]').scrollIntoView()
      cy.get('h5').contains('Watched Tasks Stats').should('be.visible')
      cy.get('[data-cy=watched_task_categories]').within(() => {
        cy.get('h5').contains('Watched Task Categories Progressions').should('be.visible')
        cy.contains('Test Task Type(milestone)').should('be.visible')
      })
      cy.get('[data-cy=watched_task_list]').within(() => {
        cy.get('h5').contains('Watched Tasks').should('be.visible')
        cy.get('[data-cy=tasks]').its('length').should('be.eq', 5)
      })
      cy.get('[data-cy=watched_tasks_vs_total]').scrollIntoView()
      cy.get('[data-cy=watched_tasks_vs_total]').within(() => {
        cy.get('h6').contains('Watched Task Categories vs Total').should('be.visible')
      })
      cy.get('[data-cy=assigned_task_users]').within(() => {
        cy.get('h6').contains('Assigned Users').should('be.visible')
        cy.get('p').contains('Total Assigned Tasks and Checklist Items').should('be.visible')
      })
    })
    cy.logout()
  })

  it('When task remove from on watch it must not appear in page', function() {
    cy.get('[data-cy=watch_view]').within(() => {
      cy.get('[data-cy=watched_task_status]').scrollIntoView()
      cy.get('[data-cy=watched_task_list]').within(() => {
        cy.get('h5').contains('Watched Tasks').should('be.visible')
        cy.get('[data-cy=tasks]').its('length').should('be.eq', 5)
        cy.get('[data-cy=tasks]').first().click()
      })
      cy.get('[data-cy=task_on_watch]').click({force: true})
      cy.wait(1000)
      cy.get('[data-cy=watched_task_list]').within(() => {
        cy.get('[data-cy=tasks]').its('length').should('be.eq', 4)
      })
    })
    cy.logout()
  })
})

describe('On watch Page tasks', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.appScenario('remove_on_watch')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openOnWatch()
  })

  it('When no task is on watch', function() {
    cy.get('[data-cy=watched_task_status]').scrollIntoView()
    cy.get('[data-cy=no_task_category_found]').contains('No Data Found..').should('be.visible')
    cy.get('[data-cy=watched_task_list]').contains('No Data Found..').should('be.visible')
    cy.logout()
  })
})
