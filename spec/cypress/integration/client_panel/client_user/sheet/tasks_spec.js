describe('Sheets Tasks View', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('client@test.com', 'T3$tClient')
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

  it('Open task from sheet task table', function() {
    cy.get('[data-cy=tasks_table]').within(() => {
      cy.get('[data-cy=task_row]').first().should('be.exist').click({force: true})
    })
    cy.get('[data-cy=task_close_btn]').should('be.exist').click({force: true})
    cy.logout()
  })

  it('Search task by typing title', function() {
    cy.get('[data-cy=tasks_table]').within(() => {
      cy.get('[data-cy=task_row]').its('length').should('be.eq', 2)
    })
    cy.get('[data-cy=search_tasks]').clear().type('task is not in the list').should('have.value', 'task is not in the list')
    cy.contains('No tasks found..').should('be.visible')

    cy.get('[data-cy=search_tasks]').clear().type('Test task').should('have.value', 'Test task')
    cy.get('[data-cy=tasks_table]').within(() => {
      cy.get('[data-cy=task_row]').its('length').should('be.eq', 1)
    })
    cy.get('[data-cy=search_tasks]').clear()
    cy.get('[data-cy=tasks_table]').within(() => {
      cy.get('[data-cy=task_row]').its('length').should('be.eq', 2)
    })
    cy.logout()
  })

  it('Sort Task list according to Task name', function() {
    cy.get('[data-cy=task_row]').first().contains('New Task').should('be.visible')
    cy.get('.mt-3 > tr > :nth-child(1)').click()
    cy.get('[data-cy=task_row]').first().contains('Test Task').should('be.visible')
    cy.get('.mt-3 > tr > :nth-child(1)').click()
    cy.get('[data-cy=task_row]').first().contains('New Task').should('be.visible')
    cy.logout()
  })

  it('Sort Task list according to Assigned User', function() {
    cy.get('.mt-3 > tr > :nth-child(5)').click()
    cy.get('[data-cy=task_row]').first().contains('Test1 Admin').should('be.visible')
    cy.get('.mt-3 > tr > :nth-child(5)').click()
    cy.get('[data-cy=task_row]').first().contains('Test1 Admin, Test2 Client').should('be.visible')
    cy.get('.mt-3 > tr > :nth-child(5)').click()
    cy.get('[data-cy=task_row]').first().contains('Test1 Admin').should('be.visible')
    cy.logout()
  })

  // it('Select task status from list to display related tasks', function() {
  //   cy.get('[data-cy=tasks_table]').within(() => {
  //     cy.get('[data-cy=task_row]').its('length').should('be.eq', 2)
  //   })
  //   cy.get('[data-cy=task_status_list]').as('list')
  //   cy.get('@list').click()
  //   cy.get('@list').within(() => {
  //     cy.contains('complete').click()
  //   })
  //   cy.contains('No tasks found..').should('be.visible')
  //   cy.get('@list').within(() => {
  //     cy.contains('all').click()
  //   })
  //   cy.get('[data-cy=tasks_table]').within(() => {
  //     cy.get('[data-cy=task_row]').its('length').should('be.eq', 2)
  //   })
  //   cy.logout()
  // })
})
